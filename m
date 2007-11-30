Return-Path: <linux-kernel-owner+w=401wt.eu-S933761AbXK3IBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933761AbXK3IBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 03:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXK3IBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 03:01:32 -0500
Received: from [196.34.54.125] ([196.34.54.125]:42848 "EHLO eng.detnet.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754923AbXK3IBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 03:01:31 -0500
X-Greylist: delayed 2197 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 03:01:29 EST
Date: Fri, 30 Nov 2007 09:15:31 +0200
From: Craig Schlenter <craig@eng.detnet.com>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: ata4294967295: failed to start port (errno=-19)
Message-ID: <20071130071531.GB4372@craigdell.detnet.com>
References: <Pine.SOC.4.64.0711281947090.15823@math.ut.ee> <20071128200716.14eccfdd@the-village.bc.nu> <5a4c581d0711291206x5d92c166iba4e4b6d336643dc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a4c581d0711291206x5d92c166iba4e4b6d336643dc@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 09:06:12PM +0100, Alessandro Suardi wrote:
> On Nov 28, 2007 9:07 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > > This message comes from 2.6.24-rc3 + todays git, version
> > > a531a141089714efe39eca89593524fdf05104f2. I did grep the logs and found
> > > that it first appeared in 2.6.24-rc1 (+ some git mayve) on Nov 3.
> > > I used 2.6.23 before that and it did not show this message.
> >
> > Can you stick a stack trace in at that point ? That would help diagnose
> > it a great deal quicker.
> 
> I've also been seeing this for a while on my Dell Latitude D610,
>  but stuff just works, so... I'm overloaded at this time, if nobody
>  gets there first I'll give a go at tracing this next week.

dmesg on my Latitude D410:

SCSI subsystem initialized
libata version 3.00 loaded.
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata4294967295: failed to start port (errno=-19)
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix

uname -a:
2.6.24-0.42.rc3.git1.fc9

Things also seem to work though.

bye,

--Craig
