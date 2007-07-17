Return-Path: <linux-kernel-owner+w=401wt.eu-S1763479AbXGQNHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763479AbXGQNHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 09:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbXGQNHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 09:07:10 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:57074 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbXGQNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 09:07:08 -0400
From: Markus <lists4me@web.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] CFS scheduler, -v19
Date: Tue, 17 Jul 2007 15:06:37 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070706173319.GA2356@elte.hu> <200707161959.17750.lists4me@web.de> <20070717073709.GA12465@elte.hu>
In-Reply-To: <20070717073709.GA12465@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707171506.37886.lists4me@web.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX192ckHsitqprwFoFaNrKbo1tAKASf44ItpFSuN+
	Bo7Z6+Ib8crzH2gllGAXN0+NEiQuJVDR0SR1QwbZdTRL/J3ck3
	MS2ZPsnXI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> could you please send me the cfs-debug-info output nevertheless?
private mail (4,9K)

> > Nothing is printed for a disapeared app for me.
> > 
> > Is there anything more I can try?
> 
> sure - could you start one of those apps via:
> 
> 	strace -ttt -TTT -o trace.log -f <app>
> 
> and wait for it to "disappear"? Then compress the trace.log via 
bzip2 -9 
> (it's probably going to be a really large file) and send me it?
private mail, aswell (187K)

When attachments are allowed, I can resend them on the list as well (or 
just ask me...)


To answer a private mail: I do not use any kernel-module thats not part 
of the official kernel!
And of course nothing proprietary
# cat /proc/sys/kernel/tainted
0

I used gcc-4.1.2 (glibc-2.5-r4) to build the kernels. (Its a amd64 
system, quite stable so far.)

Programs that "disappeared" are most graphical, because others I have 
not noticed so far... also [1] might be caused by this...
amarok, kdesktop, whole X, konqueror, konsole but also gtk-apps


   Markus


[1] http://lkml.org/lkml/2007/07/14/64
