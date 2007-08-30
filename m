Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbXH3N50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbXH3N50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 09:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbXH3N5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 09:57:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41768 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752242AbXH3N5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 09:57:14 -0400
Date: Thu, 30 Aug 2007 15:05:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Sigler <linux.kernel@free.fr>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: hda: set_drive_speed_status: status=0x51 { DriveReady
 SeekComplete Error }
Message-ID: <20070830150540.4455bd55@the-village.bc.nu>
In-Reply-To: <46D67D09.6090101@free.fr>
References: <46D59ED2.4000900@free.fr>
	<20070829174657.09c7de3c@the-village.bc.nu>
	<46D67D09.6090101@free.fr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>          Buffer size: 1.0kB      bytes avail on r/w long: 4
> 
> (Assuming an 8-bit byte, 4 bytes = 32 bits)

R/W Long is a different thing.

> When you say "the current libata IDE" do you mean PATA_VIA (in my case)?
> I've avoided this driver because it is marked EXPERIMENTAL. Would there 
> be any benefit in using it over the legacy ATA/MFM/RLL driver?

Just less warning messages

> > Basically your dinosaur is working correctly.
> 
> What do the warnings mean? :-)

Old IDE wrongly tries to issue a set features command for PIO2 to the
device. It rejects it and old IDE carries on happy
