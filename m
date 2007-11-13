Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbXKMT6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbXKMT6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 14:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbXKMT55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 14:57:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46528 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758176AbXKMT54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 14:57:56 -0500
Date: Tue, 13 Nov 2007 11:52:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Thomas Lindroth" <thomas.lindroth@gmail.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
Message-Id: <20071113115228.b722ac51.akpm@linux-foundation.org>
In-Reply-To: <3d08dbff0711130534k702f66ebj1f8e91d107eff2a1@mail.gmail.com>
References: <200711112058.28043.rjw@sisk.pl>
	<20071111200935.1384c24d@the-village.bc.nu>
	<200711112322.15537.bzolnier@gmail.com>
	<20071111224643.312f8279@the-village.bc.nu>
	<20071112171156.da6352bd.akpm@linux-foundation.org>
	<3d08dbff0711130534k702f66ebj1f8e91d107eff2a1@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2007 14:34:19 +0100 "Thomas Lindroth" <thomas.lindroth@gmail.com> wrote:

> >
> > On Sun, 11 Nov 2007 22:46:43 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk>
> > wrote:
> >
> > > > [PATCH] pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA
> > timings
> > > >
> > > > * Don't program UDMA timings when programming PIO or MWDMA modes.
> > > >
> > > >   This has also a nice side-effect of fixing regression added by
> > commit
> > > >   681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling
> > of
> > > >   SRST reset sequences") (->set_piomode method for PIO0 is called
> > before
> > > >   ->cable_detect method which checks UDMA timings to get the cable
> > type).
> > >
> > > I'm not sure this helps as if the ACPI _GTF method is looking at the
> > > flags and stuff but it has to be worth a try.
> > >
> > >
> > > Works for me as a 2.6.24 band aid
> >
> > I'm looking at that "Untested, please don't merge until it is confirmed to
> > fix the problem." comment..
> >
> > Thomas, can you please give it a try, let us know?
> >
> > Thanks
> >
> 
> I can confirm that the patch "pata_amd/pata_via: de-couple programming of
> PIO/MWDMA and UDMA timings" does fix my issue "pata_amd fails to detect
> 80-pin wire".
> 

Great, thanks for testing it.

I moved that patch to the "to send to maintainers as a 2.6.24 fix" queue. 
I should get all that material sent out hopefully tomorrow, if I can manage
to get 2.6.24-rc2-mm1 to limp out the door.
