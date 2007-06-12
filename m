Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXFLJjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXFLJjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751383AbXFLJjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:39:17 -0400
Received: from gw-e.panasas.com ([65.194.124.178]:36779 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751228AbXFLJjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:39:16 -0400
Message-ID: <466E69BE.405@vger.kernel.org>
Date: Tue, 12 Jun 2007 12:39:10 +0300
From: Linux-kernel <linux-kernel@vger.kernel.org>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: VIA C7 / VIA PC-1 (PC2500) anyone?
References: <466E65A7.3000206@msgid.tls.msk.ru>
In-Reply-To: <466E65A7.3000206@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jun 2007 09:39:12.0261 (UTC) FILETIME=[8891B350:01C7ACD5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> I bought a VIA PC2500 board a few days ago - this
> new series of their mobos,
> 
> This beast looks nice - after replacing their cooling
> system (that had a small fan on it) with larger but
> fanless, -- it becomes a almost real PC (1500MHz CPU),
> equipped with quite nice crypto and multimedia abilities,
> but with very low power consumption and very quiet.
> 
> But the thing is - it doesn't quite work.
> 
> It works generally - it boots, I can run my usual apps
> etc.  But on a random (yet frequent) basis it segfaults
> here and there.  For example:
> 
> $ man man
> Reformatting man(1), please wait...
> $ man man
> Segmentation fault
> $ man man
> Segmentation fault
> $ man man
> Segmentation fault
> $ man man
> Segmentation fault
> $ man man
> Reformatting man(1), please wait...
> $ _
> 
> (this is 100% idle machine, just booted).
> 
> (There are other - simple and comples - applications which
> inhibits this problem.  For example, it 99% reliable segfaults
> on compiling aic79xx_core.c file in kernel, while all the rest
> (in my configuration anyway) compiles, at least after second
> attempt).
> 
> It's definitely NOT memory issue - I tried several different
> memory modules (and different combinations) - the same results;
> I ran memtest86 for several days - no single error.
> 
> I've seen a thread here on LKML about C7 and C3 CPUs back in
> March this year - tried with patch from Andi titled
> "i386: Enable CX8/PGE CPUID bits early on VIA C3" - it didn't
> change anything (this board does not lock up - not when booting
> nor when doing something, -- just random applications are
> crashing randomly, and the crash is always SIGSEGV; there's
> _nothing_ in dmesg about that, too).
> 
> From all the above it seems like something's broke on the
> motherboard (I've no idea what it can be however - because
> memory testing - which also tests for CPU cache for exampe -
> shows no errors; testing disk controller/disk using md5 does
> not show errors either, except of occasional SIGSEGVs)..
> 
> However, being very curious about this, I tried installing
> 'doze on this machine - winXP.  And that one went just fine
> without any error so far -- i tried stress-testing it as far
> as I can imagine, running various applications and workloads, --
> no errors.
> 
> So I'm kinda.. stuck about what to do next.
> 
> Any.. idea, anyone? :)
> 
> Thanks!
> 
> /mjt

To me it looks like a wrong choice of gcc switches to user-mode programs. What
distribution are you using? try compiling failing programs from source with
conservative command line switches to gcc. See if things change.

Boaz

