Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbYL2Ro4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbYL2Ro4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 12:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbYL2Ros
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 12:44:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYL2Ros (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 12:44:48 -0500
Message-ID: <49590C65.3060804@zytor.com>
Date: Mon, 29 Dec 2008 09:44:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 byteorder.h: use __asm__/__inline__ for userspace
References: <1230360604-6711-1-git-send-email-vapier@gentoo.org> <200812271557.07003.vapier@gentoo.org> <495699A0.10305@zytor.com> <200812290656.32827.vapier@gentoo.org>
In-Reply-To: <200812290656.32827.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Saturday 27 December 2008 16:09:52 H. Peter Anvin wrote:
>> Mike Frysinger wrote:
>>> ...
>>> #ifdef __KERNEL__
>>> # define kernel_flock flock
>>> #endif
>>> struct kernel_flock {
>>> ...
>> FWIW, a long time ago I proposed the __kabi_ prefix for these things; I
>> think it is a good thing to make userspace-visible structures stand out
>> even in the kernel code itself.
>>
>> As such, I would suggest *not* adding the #define at all.
> 
> the convention based on linux/types.h seems to be to use __kernel_ as the 
> prefix, but it doesnt matter to me whether it's __kabi_ or __kernel_.  i'll 
> start doing the latter though in the hopes it'll be less scary ;).

Agreed, the actual prefix doesn't matter.  I suggested __kabi to be more
explicit about the fact that it is an exported ABI, but I think the main
thing is to not #define it out.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

