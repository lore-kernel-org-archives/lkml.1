Return-Path: <linux-kernel-owner+w=401wt.eu-S1764892AbXEUXOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764892AbXEUXOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbXEUXOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:14:05 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59027 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756587AbXEUXOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:14:04 -0400
Date: Tue, 22 May 2007 00:18:37 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Cc: hancockr@shaw.ca (Robert Hancock),
       jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org
Subject: Re: IDE/ATA: Intel i865-based mainboard, CDROM not detected
Message-ID: <20070522001837.5104bfe1@the-village.bc.nu>
In-Reply-To: <200705212305.l4LN5irk008924@turbo.physics.adelaide.edu.au>
References: <465150C2.4080006@shaw.ca>
	<200705212305.l4LN5irk008924@turbo.physics.adelaide.edu.au>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This would be your PATA port - pata_marvell.

> 02:00.0 IDE interface: Marvell Technology Group Ltd. Unknown device 6101 (rev b1) (prog-if 8f [Master SecP SecO PriP PriO])
> 	Subsystem: Marvell Technology Group Ltd. Unknown device 6101

> Does this apply to *all* SATA controllers or just these ICHx ones from
> Intel?  In other words, should all optimally configured SATA controllers
> be in AHCI mode?

If they have an AHCI mode then currently yes. AHCI is a well designed
interface with nice functionality. None of the devices which support
multiple modes of operation have any custom mode that is nicer .. so far
anyway.

Alan
