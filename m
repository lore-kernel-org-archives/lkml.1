Return-Path: <linux-kernel-owner+w=401wt.eu-S1756641AbXKMOJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641AbXKMOJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 09:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXKMOJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 09:09:07 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:39874 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbXKMOJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 09:09:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=frvYMbJv9xXOBq48R5bTAhQ7mveBQfzGcz005r5Ag7n/gWNQofSSpchV0MfZ4tNOUHdb3ObiVPz9nkgnPzmm7ggnukUYIWh1650sgPfXDnuw62/MIFWoCQkO6A9058Mgxo3b1rejojRjlkGgp9PYfKYS72vhSSsBWxnyuGI/30E=
Message-ID: <3d08dbff0711130609u462619c9n5f87e9c0e55eb46@mail.gmail.com>
Date: Tue, 13 Nov 2007 15:09:04 +0100
From: "Thomas Lindroth" <thomas.lindroth@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Reported regressions from 2.6.23 (updated)
In-Reply-To: <20071112171156.da6352bd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200711112058.28043.rjw@sisk.pl>
	 <20071111200935.1384c24d@the-village.bc.nu>
	 <200711112322.15537.bzolnier@gmail.com>
	 <20071111224643.312f8279@the-village.bc.nu>
	 <20071112171156.da6352bd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > [PATCH] pata_amd/pata_via: de-couple programming of PIO/MWDMA and UDMA timings
> > >
> > > * Don't program UDMA timings when programming PIO or MWDMA modes.
> > >
> > >   This has also a nice side-effect of fixing regression added by commit
> > >   681c80b5d96076f447e8101ac4325c82d8dce508 ("libata: correct handling of
> > >   SRST reset sequences") (->set_piomode method for PIO0 is called before
> > >   ->cable_detect method which checks UDMA timings to get the cable type).
> >
> > I'm not sure this helps as if the ACPI _GTF method is looking at the
> > flags and stuff but it has to be worth a try.
> >
> >
> > Works for me as a 2.6.24 band aid
>
> I'm looking at that "Untested, please don't merge until it is confirmed to
> fix the problem." comment..
>
> Thomas, can you please give it a try, let us know?
>
> Thanks
>

I can confirm that the patch "pata_amd/pata_via: de-couple programming
of PIO/MWDMA and UDMA timings" does fix my issue "pata_amd fails to
detect 80-pin wire".
