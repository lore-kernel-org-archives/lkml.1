Return-Path: <linux-kernel-owner+w=401wt.eu-S1754018AbZH3UEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbZH3UEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 16:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZH3UEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 16:04:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbZH3UEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 16:04:23 -0400
Message-ID: <4A9ADB24.6000100@zytor.com>
Date: Sun, 30 Aug 2009 13:03:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [PATCH 2/3] x86, msr: rewrite AMD rd/wrmsr variants
References: <1251633031-2244-1-git-send-email-petkovbb@gmail.com> <1251633031-2244-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1251633031-2244-2-git-send-email-petkovbb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2009 04:50 AM, Borislav Petkov wrote:
> +#define memset(d,c,l) __builtin_memset(d,c,l)

Uh, *NO*.

#include <linux/string.h> instead.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

