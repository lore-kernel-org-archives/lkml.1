Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXGaJha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXGaJha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 05:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbXGaJhV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 05:37:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55829 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752957AbXGaJhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 05:37:20 -0400
Date: Tue, 31 Jul 2007 10:44:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Avi Kivity <avi@argo.co.il>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ck@vds.kolivas.org
Subject: Re: SD still better than CFS for 3d   ?(was Re: 2.6.23-rc1)
Message-ID: <20070731104412.3930e147@the-village.bc.nu>
In-Reply-To: <46AEFE9E.1000204@argo.co.il>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
	<1185536610.502.8.camel@localhost>
	<20070729170641.GA26220@elte.hu>
	<1185839164.27166.7.camel@localhost>
	<1185863461.3092.4.camel@twins>
	<20070731085713.GA15136@elte.hu>
	<20070731101133.5ae6ac79@the-village.bc.nu>
	<20070731091359.GB15136@elte.hu>
	<46AEFE9E.1000204@argo.co.il>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > oh, wonderful! Alan, you are a true wizard :-) The tty layer is one of 
> > the very few pieces of kernel code that scares the hell out of me :-)

I'm not too fond of the way it does some stuff either especially the open
v close v hangup paths but that is partly the fault of POSIX 8)

> Maybe it should be kept crufty then.  Every kernel developer should have 
> at least one part of the kernel he's afraid to go into ;-)

floppy.c is sufficient
