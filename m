Return-Path: <linux-kernel-owner+w=401wt.eu-S1755797AbZKNMEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797AbZKNMEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 07:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755604AbZKNMEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 07:04:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:45589 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbZKNMEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 07:04:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=iZZYCbgLagf8EjFFoMZQnUCLpO+ZO+XDgoMEBPcoNFw7yUpQqqGQFPM8UIJWg1TU7H
         wtvWKfG68kT5xEsGPATCNucMQsVlukpoT6yNzXJoES+twIGCibWeOyFCB8656rreC3aL
         GDBqupxiwyEPiwoPw8yCXTfU2GMYpapHDlIUA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] libata: remove experimental tag on PATA drivers
Date: Sat, 14 Nov 2009 13:02:46 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockrwd@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
       Jonathan Corbet <corbet@lwn.net>
References: <4AFCC0D4.9020708@gmail.com> <20091114022951.GA9796@srcf.ucam.org> <200911140354.01808.bzolnier@gmail.com>
In-Reply-To: <200911140354.01808.bzolnier@gmail.com>
MIME-Version: 1.0
Message-Id: <200911141302.46714.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 November 2009 03:54:01 Bartlomiej Zolnierkiewicz wrote:
> On Saturday 14 November 2009 03:29:51 Matthew Garrett wrote:
> > On Sat, Nov 14, 2009 at 12:46:29AM +0100, Bartlomiej Zolnierkiewicz wrote:
> > 
> > > Skipping the technical merit of the quoted text for the moment -- I find
> > > the fact that you keep calling the present IDE host drivers (that many
> > > developers helped to fix) as "old" ones or "buggy" ones rather degrading
> > > for their (this includes me of course) hard work.
> > 
> > Without making any judgement about the relative quality of the drivers 
> > in their role as IDE drivers, the fact that ACPI hotplug works with 
> > libata and doesn't work with drivers/ide means that, rationally, 
> > distributions need to use the libata stack for the more common parts. 
> 
> This doesn't change the fact that there are real regressions present in
> libata host drivers and people who should be responsible for fixing them
> are just ignoring them..
> 
> > There simply isn't the same level of integration between drivers/ide and 
> > the rest of the OS.
> 
> Fully agreed but it doesn't change anything for issues discussed.
> 
> On the side note -- certain distributions, I'm sure you know which one
> I mean specifically [1],  "helped" a lot in making sure that such level
> of integration would be very difficult to achieve (ACPI hotplug was
> added later than some distributions, again you know which one I mean
> specifically [1], switched to libata _only_ for PATA).

I've checked this now:

	23 January 2007	F7 Test1 development freeze 
	..
	31 May 2007	F7 General Availability

vs.

ommit 237d8440cb2b104a3b97fc971a9bce67960bb616
Author:     Matthew Garrett <mjg59@srcf.ucam.org>
AuthorDate: Wed Oct 3 01:24:16 2007 +0100
Commit:     Jeff Garzik <jeff@garzik.org>
CommitDate: Fri Oct 12 14:55:45 2007 -0400

    libata: Integrate ACPI-based PATA/SATA hotplug - version 5

    Modern laptops with hotswap bays still tend to utilise a PATA interface
    on a SATA bridge, generally with the host controller in some legacy
    emulation mode rather than AHCI. This means that the existing hotplug
    code in libata is unable to work. The ACPI specification states that
    ...

Please take a look at dates and author of the commit.

You helped create such situation in the first place and now you try to
use it as an technical argument to justify past decisions.

Anyway it doesn't matter here at all.

Why are people even bringing this or quality of "old" IDE host drivers
in the discussion as a justification for the quality of _new_ drivers?

Double standards and hypocrisy comes to a mind.

-- 
Bartlomiej Zolnierkiewicz
