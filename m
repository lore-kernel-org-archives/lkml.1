Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZLURRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZLURRp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:17:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbZLURRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:17:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbZLURRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:17:44 -0500
Message-ID: <4B2FAD7B.7050701@zytor.com>
Date: Mon, 21 Dec 2009 09:16:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix size for ex trampoline with 32bit
References: <4B2F237F.3040909@kernel.org>
In-Reply-To: <4B2F237F.3040909@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2009 11:27 PM, Yinghai Lu wrote:
> 
> 
> fix for error that is introduced by
> | x86: Use find_e820() instead of hard coded trampoline address
> 
> it should end with PAGE_SIZE + PAGE_SIZE
> 

2*PAGE_SIZE?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

