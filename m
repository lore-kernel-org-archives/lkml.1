Return-Path: <linux-kernel-owner+w=401wt.eu-S1752000AbXCLXCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000AbXCLXCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 19:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbXCLXCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 19:02:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54322 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752000AbXCLXBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 19:01:49 -0400
Date: Tue, 13 Mar 2007 00:04:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Phil Kaslo <phil@cs.arizona.edu>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Asus P5B-VM motherboard:  cd drive malfunctions if internal nic
 in use.
Message-ID: <20070313000459.6739c3cb@lxorguk.ukuu.org.uk>
In-Reply-To: <45F5D59E.10304@rtr.ca>
References: <200703122212.l2CMCaxm032601@osprey.cs.arizona.edu>
	<45F5D59E.10304@rtr.ca>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Is that a PATA cd-drive?  If so, then you must have hooked it up
> to the JMicron IDE controller.  That driver is just plain buggy.

It ought to be rock solid, perhaps you can send me a detailed bug report.
In fact it actually doesn't do very much at all as the controller is
smart enough to do all the hard work itself.

> I gave up on it for my own P5B-VM.  The libata version works better
> than the drivers/ide, but I gave up on it and got a SATA DVD/RW drive.

The two drive the devices identically although if there was a problem I
guess the libata one would recover better.

Would appreciate bug reports anyway so I can do more detailed analysis.

Alan
