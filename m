Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbXGJF0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbXGJF0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 01:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbXGJF0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 01:26:15 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55441 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbXGJF0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 01:26:14 -0400
Message-ID: <46931840.1050002@garzik.org>
Date: Tue, 10 Jul 2007 01:25:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Subject: Re: x86 setup code rewrite in C
References: <11840359321823-git-send-email-hpa@zytor.com>
In-Reply-To: <11840359321823-git-send-email-hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> This patch set replaces the x86 setup code, which is currently all in
> assembly, with a version written in C, using the ".code16gcc" feature
> of binutils (which has been present since at least 2001.)
> 
> The new code is vastly easier to read, and, I hope, debug.  It should
> be noted that I found a fair number of minor bugs while going through
> this code, and have attempted to correct them.
> 
> In the process of doing so, it introduces several cleanups, in
> particular:
> 
> - Obsoletes the hd_info field in the boot_params structure; they are
>   only ever used for ST-506 (pre-IDE) drives and are pretty much
>   guaranteed to be wrong on current BIOSes;
> - Unifies the CPU feature bits between i386 and x86-64.  In the
>   future, it should be possible to use arch/i386/boot/cpucheck.c to do
>   the post-invocation CPU check currently done in
>   arch/x86_64/kernel/trampoline.S, although this patch set doesn't
>   introduce that change.
> - boot_params is now a proper structure.
> 
> This code has been tested in -mm since early in the 2.6.22 cycle.

ACK

I don't claim to be an expert in this area, but I definitely support 
this going in, and I really did read every patch.  :)

The only minor problem I found was a misspelling "paragrap" (perhaps 
plural) in one of the patches.

	Jeff


