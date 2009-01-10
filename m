Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbZAJPby@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbZAJPby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 10:31:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752064AbZAJPbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 10:31:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48266 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751975AbZAJPbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 10:31:44 -0500
Date: Sat, 10 Jan 2009 15:29:42 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: todays git: WARNING: at drivers/ata/libata-sff.c:1017
 ata_sff_hsm_move+0x45e/0x750()
Message-ID: <20090110152942.11375c6c@lxorguk.ukuu.org.uk>
In-Reply-To: <1231600972.3642.22.camel@localhost.localdomain>
References: <200901091334.55823.borntraeger@de.ibm.com>
	<200901101009.13699.borntraeger@de.ibm.com>
	<20090110104114.633cacd8@lxorguk.ukuu.org.uk>
	<200901101242.05203.borntraeger@de.ibm.com>
	<49688B63.5030105@ru.mvista.com>
	<20090110122130.318cf168@lxorguk.ukuu.org.uk>
	<1231598170.3642.12.camel@localhost.localdomain>
	<20090110151248.063199d2@lxorguk.ukuu.org.uk>
	<1231600972.3642.22.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Nope.. you can't do that with ATA block transfers - it isn't the same as
> > SCSI
> 
> Well, in that case you'll have to do byte PIO for all ATAPI devices,
> because this is an expected device to host transfer length.

Not possible there is no such thing as byte PIO in ATAPI.

See my other mail - it appears to be a long standing bug in
__atapi_pio_sector rather than a corrupt sg list as I first thought.
