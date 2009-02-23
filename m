Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZBWSd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZBWSd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZBWSds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:33:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbZBWSdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:33:47 -0500
Message-ID: <49A2EBD0.2020303@zytor.com>
Date: Mon, 23 Feb 2009 10:32:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: Linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>,
       Chuck Ebbert <76306.1226@compuserve.com>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [patch] small fix to espfix code
References: <49A2CB13.4080708@aknet.ru>
In-Reply-To: <49A2CB13.4080708@aknet.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stas Sergeev wrote:
> 
> The bug is mostly theoretical, I can't
> really test the effect of this patch.
> So, it is completely untested.
> 

It's not a bug, as the stack is aligned such that 16-bit overflow can't 
happen.  However, it is arguably cleaner to have addl here.

	-hpa
