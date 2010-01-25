Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289Ab0AYViV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab0AYViV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:38:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892Ab0AYViU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:38:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52143 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805Ab0AYViU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:38:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: sboyce@blueyonder.co.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: HDA Intel Audio hang on boot
Date: Mon, 25 Jan 2010 22:39:02 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <4B4FC3B0.9070207@blueyonder.co.uk> <4B5CF87A.20101@blueyonder.co.uk>
In-Reply-To: <4B5CF87A.20101@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001252239.03017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Sid Boyce wrote:
> On 15/01/10 01:24, Sid Boyce wrote:
> This is the only outstanding bug. No problems up 2.6.32-git1, but I get
> a solid lock-up on 2.6.32-git2 through 2.6.33-rc5 if the on-board audio
> is not disabled in the BIOS.

I guess we should let Takashi know.
 
> > tindog:~ # uname -r
> > 2.6.33-rc4-smp
> > On 2.6.32-git1 which boots, hwinfo shows:-
> >   oss.card_id = 'HDA NVidia'
> >   oss.card_id = 'HDA NVidia'
> >   oss.card_id = 'HDA NVidia'
> >   alsa.card_id = 'HDA NVidia'
> >   alsa.card_id = 'HDA NVidia'
> >   alsa.card_id = 'HDA NVidia'
> >   alsa.card_id = 'HDA NVidia'
> >   info.product = 'HDA NVidia ALSA hardware specific Device'
> >   alsa.card_id = 'HDA NVidia'
> >   info.product = 'HDA NVidia ALSA Control Device'
> >   alsa.card_id = 'HDA NVidia'
> >   info.product = 'HDA NVidia Sound Card'
> >   sound.card_id = 'HDA NVidia'
> >   info.linux.driver = 'HDA Intel'
> >     22:     489835        578   IO-APIC-fasteoi   sata_nv, HDA Intel
> >        HDA Intel: /devices/pci0000:00/0000:00:0e.1
> >        HDA Intel: module = snd_hda_intel
> > irq:0 22 (   490413) "sata_nv" "HDA Intel"
> >        HDA Intel: /devices/pci0000:00/0000:00:0e.1
> >        HDA Intel: module = snd_hda_intel
> >        HDA Intel: /devices/pci0000:00/0000:00:0e.1
> >        HDA Intel: module = snd_hda_intel
> >   E: DRIVER=HDA Intel
> >   <6>HDA Intel 0000:00:0e.1: PCI INT B -> Link[AAZA] -> GSI 22 (level,
> > low) -> IRQ 22
> >   <7>HDA Intel 0000:00:0e.1: setting latency timer to 64
> >   Driver: "HDA Intel"

Rafael
