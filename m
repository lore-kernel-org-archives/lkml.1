Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbXIVQJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbXIVQJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 12:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbXIVQIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 12:08:54 -0400
Received: from echo.digadd.de ([195.47.195.234]:48209 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754370AbXIVQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 12:08:53 -0400
X-Greylist: delayed 1669 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Sep 2007 12:08:53 EDT
Message-ID: <46F53793.3020102@digadd.de>
Date: Sat, 22 Sep 2007 18:41:07 +0300
From: "Christian P. Schmidt" <charlie@digadd.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Memory allocation problem with 2.6.22 after suspend/resume cycle
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm having a strange problem, of course not reproducible. Sometimes
after a suspend (to ram) and resume cycle, the kernel will try to free
all memory. This means, all running applications are flushed to swap (as
long as it is available), caches and buffers stay at around 15MB each.

The following video (traded quality for bandwidth) shows what happens on
the way from no swap to "swapon -a" (that's the unreadable thing in the
small shell): http://digadd.de/swapping.avi

The system:
Linux dnnote 2.6.22.5 #1 SMP PREEMPT Sat Aug 25 18:39:21 AST 2007 x86_64
Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux

A 32bit Kernel is unable to suspend/resume at all. No idea why. dmesg
shows nothing, logs show nothing. Any ideas for debugging are welcome.

Regards,
Chris
