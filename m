Return-Path: <linux-kernel-owner+w=401wt.eu-S1752979AbXFLJV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752979AbXFLJV4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 05:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbXFLJVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 05:21:49 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:21549 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXFLJVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 05:21:48 -0400
Message-ID: <466E65A7.3000206@msgid.tls.msk.ru>
Date: Tue, 12 Jun 2007 13:21:43 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: VIA C7 / VIA PC-1 (PC2500) anyone?
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I bought a VIA PC2500 board a few days ago - this
new series of their mobos,

This beast looks nice - after replacing their cooling
system (that had a small fan on it) with larger but
fanless, -- it becomes a almost real PC (1500MHz CPU),
equipped with quite nice crypto and multimedia abilities,
but with very low power consumption and very quiet.

But the thing is - it doesn't quite work.

It works generally - it boots, I can run my usual apps
etc.  But on a random (yet frequent) basis it segfaults
here and there.  For example:

$ man man
Reformatting man(1), please wait...
$ man man
Segmentation fault
$ man man
Segmentation fault
$ man man
Segmentation fault
$ man man
Segmentation fault
$ man man
Reformatting man(1), please wait...
$ _

(this is 100% idle machine, just booted).

(There are other - simple and comples - applications which
inhibits this problem.  For example, it 99% reliable segfaults
on compiling aic79xx_core.c file in kernel, while all the rest
(in my configuration anyway) compiles, at least after second
attempt).

It's definitely NOT memory issue - I tried several different
memory modules (and different combinations) - the same results;
I ran memtest86 for several days - no single error.

I've seen a thread here on LKML about C7 and C3 CPUs back in
March this year - tried with patch from Andi titled
"i386: Enable CX8/PGE CPUID bits early on VIA C3" - it didn't
change anything (this board does not lock up - not when booting
nor when doing something, -- just random applications are
crashing randomly, and the crash is always SIGSEGV; there's
_nothing_ in dmesg about that, too).

>From all the above it seems like something's broke on the
motherboard (I've no idea what it can be however - because
memory testing - which also tests for CPU cache for exampe -
shows no errors; testing disk controller/disk using md5 does
not show errors either, except of occasional SIGSEGVs)..

However, being very curious about this, I tried installing
'doze on this machine - winXP.  And that one went just fine
without any error so far -- i tried stress-testing it as far
as I can imagine, running various applications and workloads, --
no errors.

So I'm kinda.. stuck about what to do next.

Any.. idea, anyone? :)

Thanks!

/mjt
