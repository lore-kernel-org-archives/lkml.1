Return-Path: <linux-kernel-owner+w=401wt.eu-S1757318AbXHBQwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318AbXHBQwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 12:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbXHBQwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 12:52:38 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50094 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750823AbXHBQwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 12:52:37 -0400
Date: Thu, 2 Aug 2007 17:57:11 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Mark Lord <lkml@rtr.ca>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Lee Howard <faxguy@howardsilvan.com>, linux-serial@vger.kernel.org,
       tytso@mit.edu, linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
Message-ID: <20070802175711.12bdcaec@the-village.bc.nu>
In-Reply-To: <46B202DE.5000709@shaw.ca>
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>
	<46A84B4A.6070902@shaw.ca>
	<46A8C6F1.4080309@howardsilvan.com>
	<Pine.LNX.4.64N.0707271216410.425@blysk.ds.pg.gda.pl>
	<46AA2748.80703@howardsilvan.com>
	<Pine.LNX.4.64N.0707271825220.425@blysk.ds.pg.gda.pl>
	<46AA3801.7090204@shaw.ca>
	<20070728092842.GC26443@flint.arm.linux.org.uk>
	<Pine.LNX.4.64N.0707301040320.12082@blysk.ds.pg.gda.pl>
	<46B1F0CB.9060106@rtr.ca>
	<46B202DE.5000709@shaw.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I think that PIO transfers only have to be done with interrupts disabled 
> on really old, evil controllers (without unmask set). I don't think 
> libata ever disables interrupts during transfers(?)

Currently libata PIO is mostly done in the IRQ path. Albert Lee was doing
some work on that but its actually very hard to fix without doing polled
PIO.

