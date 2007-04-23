Return-Path: <linux-kernel-owner+w=401wt.eu-S1030984AbXDWDTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030984AbXDWDTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 23:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030982AbXDWDTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 23:19:40 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:39819 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030984AbXDWDTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 23:19:40 -0400
Message-ID: <462C25C9.9040107@zachcarter.com>
Date: Sun, 22 Apr 2007 20:19:37 -0700
From: Zach Carter <linux@zachcarter.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch] CFS scheduler, -v5 (build problem - make headers_check
 fails)
References: <20070420140457.GA14017@elte.hu> <20070423011229.GA20367@elte.hu>
In-Reply-To: <20070423011229.GA20367@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
> i'm pleased to announce release -v5 of the CFS scheduler patchset. The 
> patch against v2.6.21-rc7 and v2.6.20.7 can be downloaded from:
> 

FYI, make headers_check seems to fail on this:

[carter@hoth linux-2.6]$ make headers_check

[snip]

   CHECK   include/linux/usb/cdc.h
   CHECK   include/linux/usb/audio.h
make[2]: *** No rule to make target `/src/linux-2.6/usr/include/linux/.check.sched.h', needed by 
`__headerscheck'.  Stop.
make[1]: *** [linux] Error 2
make: *** [headers_check] Error 2
[carter@hoth linux-2.6]$

This also fails if I have CONFIG_HEADERS_CHECK=y in my .config

unset CONFIG_HEADERS_CHECK and it builds just fine.

-Zach
