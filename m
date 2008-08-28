Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYH1BbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYH1BbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbYH1Baq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:30:46 -0400
Received: from 181-30.bbned.dsl.internl.net ([82.215.30.181]:56467 "HELO
	hubble.stokkie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753614AbYH1Bao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:30:44 -0400
Date: Thu, 28 Aug 2008 03:30:42 +0200 (CEST)
From: "Robert M. Stockmann" <stock@stokkie.net>
To: Jeff Garzik <jeff@garzik.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: libata, Sound on same IRQ : flaky sound
In-Reply-To: <48B5F877.8030506@garzik.org>
Message-ID: <Pine.LNX.4.44.0808280320470.31973-100000@hubble.stokkie.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiVirus: scanned for viruses by AMaViS 0.2.4 (ftp://crashrecovery.org/pub/linux/amavis/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Jeff Garzik wrote:

> Date: Wed, 27 Aug 2008 20:59:35 -0400
> From: Jeff Garzik <jeff@garzik.org>
> To: Robert M. Stockmann <stock@stokkie.net>
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: libata, Sound on same IRQ : flaky sound
> 
> Robert M. Stockmann wrote:
> > Hi,
> > 
> > I have a couple of AMD64 machines with onboard sound devices running 
> > and they all have one thing in common : flaky sound when one is 
> > doing some heavy disk I/O on the SATA disks. Interesting enough 
> > /proc/interrupts shows that libata is using the same IRQ as the sound 
> > devices :
> > 
> > model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 6000+
> > stepping        : 3
> > cpu MHz         : 3014.679
> > cache size      : 1024 KB
> > 
> > # cat /proc/interrupts 
> >            CPU0       CPU1       
> >   0:      55869  154467838    IO-APIC-edge  timer
> >   8:          0          0    IO-APIC-edge  rtc
> >   9:          0          0   IO-APIC-level  acpi
> >  16:       1453     499686   IO-APIC-level  libata, NVidia CK8S
> >  17:          0          0   IO-APIC-level  ehci_hcd:usb1
> >  18:      27633   69978987   IO-APIC-level  eth0
> > NMI:      10718      12112 
> > LOC:  154533874  154533852 
> > ERR:          0
> > MIS:          0
> 
> What is the behavior of a recent kernel?
> 
> Is your SATA interface set to legacy mode in BIOS?
> 

the BIOS supports raid0, but the sata disks are running standalone
as /dev/sda /dev/sdb etc.

installing a recent kernel is not that easy, as the required
upgrade of udev will break the initscripts and a lot of installed
services and even the functionality of the KDE desktop. Installing
a recent distro is not desirable as they resemble me only
of a Open Source Vista distro, where it takes months to clean
up the unwanted garbage and bloat inside. Its preposterous that
a upgrade to a recent kernel mandates the installation of a recent
distro. I run Mandrake 10.1 with kernel 2.6.15 and some applications
upgraded like firefox, mplayer and k3b etc.

Robert
-- 
Robert M. Stockmann - RHCE
Network Engineer - UNIX/Linux Specialist
crashrecovery.org  stock@stokkie.net

