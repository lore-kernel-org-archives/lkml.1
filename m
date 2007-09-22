Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbXIVVrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbXIVVrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 17:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751884AbXIVVq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 17:46:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621AbXIVVq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 17:46:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Christian P. Schmidt" <charlie@digadd.de>
Subject: Re: Memory allocation problem with 2.6.22 after suspend/resume cycle
Date: Sun, 23 Sep 2007 00:00:09 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>
References: <46F53793.3020102@digadd.de>
In-Reply-To: <46F53793.3020102@digadd.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709230000.09722.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 22 September 2007 17:41, Christian P. Schmidt wrote:
> Hi all,
> 
> I'm having a strange problem, of course not reproducible. Sometimes
> after a suspend (to ram) and resume cycle, the kernel will try to free
> all memory. This means, all running applications are flushed to swap (as
> long as it is available), caches and buffers stay at around 15MB each.
> 
> The following video (traded quality for bandwidth) shows what happens on
> the way from no swap to "swapon -a" (that's the unreadable thing in the
> small shell): http://digadd.de/swapping.avi
> 
> The system:
> Linux dnnote 2.6.22.5 #1 SMP PREEMPT Sat Aug 25 18:39:21 AST 2007 x86_64
> Intel(R) Core(TM)2 CPU T7400 @ 2.16GHz GenuineIntel GNU/Linux

Are you using an ATI binary graphics driver?
 
> A 32bit Kernel is unable to suspend/resume at all. No idea why. dmesg
> shows nothing, logs show nothing. Any ideas for debugging are welcome.

Well, that's interesting.

Can you try in the minimal configuration (ie. boot with init=/bin/bash,
mount /sys, mount /proc and run "echo mem > /sys/power/disk)?

Greetings,
Rafael
