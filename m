Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbXK3NSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbXK3NSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:18:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbXK3NRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:17:49 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41852 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763825AbXK3NRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:17:48 -0500
Date: Fri, 30 Nov 2007 13:13:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Tejun Heo <htejun@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       noah <noah123@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: Possibly SATA related freeze killed networking and RAID
Message-ID: <20071130131344.07b75f45@the-village.bc.nu>
In-Reply-To: <474F3A4B.3080304@cfl.rr.com>
References: <d00698fb0711201109m23ff096eiabeb22c8f9a917dc@mail.gmail.com>
	<20071120220512.46b9e975@the-village.bc.nu>
	<20071126120649.GC4701@ucw.cz>
	<474CCA82.7030000@gmail.com>
	<474F3A4B.3080304@cfl.rr.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why does a single spurious interrupt cause it to be shut down?  I can 

It doesn't.

> see if the interrupt is stuck on and keeps interrupting constantly, but 
> if it's just the occasional spurious interrupt, why not just ignore it 
> and move on?

The interrupt is usually level triggered so it continues to create
interrupts until you silence it. The thresholds are about 10,000
interrupt events and on newer kernels we also reset the count if we don't
see any for a while. That works for most stuff except the thinkpad
bluetooth problem.

