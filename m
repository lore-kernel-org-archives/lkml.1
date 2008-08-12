Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYHLHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYHLHf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 03:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYHLHfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 03:35:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52124 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbYHLHfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 03:35:18 -0400
Date: Tue, 12 Aug 2008 08:16:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Maciej Rutecki" <maciej.rutecki@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Jeff Garzik" <jgarzik@pobox.com>,
       tj@kernel.org, andi@firstfloor.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [2.6.26.*] boot problem (ahci/irq related?)
Message-ID: <20080812081632.303de380@lxorguk.ukuu.org.uk>
In-Reply-To: <86802c440808112352j2175d2edlf421c44499f8c1c0@mail.gmail.com>
References: <8db1092f0808111312x3baf819bxbb05030c05693065@mail.gmail.com>
	<20080811202731.GB2916@elte.hu>
	<86802c440808112352j2175d2edlf421c44499f8c1c0@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +sr 4:0:0:0: Attached scsi CD-ROM sr0
> 
> looks like you are using ata driver for pata device instead of ide driver.
> 
> so could be caused by bug in ata_piix...

See the original bug report - he tried both and got the same kind of
behaviour.

