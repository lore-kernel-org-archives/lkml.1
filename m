Return-Path: <linux-kernel-owner+w=401wt.eu-S933853AbXEEVpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853AbXEEVpw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:45:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933921AbXEEVpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:45:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:56557 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933853AbXEEVpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:45:52 -0400
Date: Sat, 5 May 2007 22:49:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: Paul Fulghum <paulkf@microgate.com>,
       Antonino Ingargiola <tritemio@gmail.com>,
       linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
 possible bug]
Message-ID: <20070505224949.2adb378b@the-village.bc.nu>
In-Reply-To: <200705051854.30843.oliver@neukum.org>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	<1178381287.3379.8.camel@x2>
	<20070505173647.544f6707@the-village.bc.nu>
	<200705051854.30843.oliver@neukum.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is a bug in cdc-acm really. It should not double buffer, but to be
> > fair to the authors prior to the new tty buffering it *had* to do this.
> 
> I assume this applies to all serial drivers in the wider sense?

When possible at least. Obviously there will always be some buffering in
the hardware or interface glue but you should never need to work around
the tty buffers now.

Alan
