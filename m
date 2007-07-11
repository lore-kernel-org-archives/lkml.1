Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbXGKUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbXGKUI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 16:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762529AbXGKUIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 16:08:19 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45427 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757145AbXGKUIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 16:08:18 -0400
Message-ID: <469538A9.4010202@garzik.org>
Date: Wed, 11 Jul 2007 16:08:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: torvalds@linux-foundation.org, andi@firstfloor.org,
       linux-kernel@vger.kernel.org
Subject: Re: x86 setup code rewrite in C - revised
References: <1184181538674-git-send-email-hpa@zytor.com>
In-Reply-To: <1184181538674-git-send-email-hpa@zytor.com>
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
> This patchset incorporates all feedback received by 2007-07-11 12:00 PDT.

I'm sure you know what's changed since the last revision, but nobody 
everybody does :)  It would be nice to know what's different from the 
last posting.

	Jeff



