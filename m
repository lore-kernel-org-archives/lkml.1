Return-Path: <linux-kernel-owner+w=401wt.eu-S1759276AbZEFAqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759276AbZEFAqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 20:46:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZEFAqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 20:46:13 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:20231 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754159AbZEFAqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 20:46:12 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 May 2009 20:46:08 EDT
Date: Wed, 6 May 2009 10:38:58 +1000 (EST)
From: Tim Connors <tconnors+linuxkml@astro.swin.edu.au>
To: Tejun Heo <tj@kernel.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
Subject: Re: sata_sil24 EH complete
In-Reply-To: <4A00DA98.5060201@kernel.org>
Message-ID: <alpine.DEB.2.00.0905061038340.14678@dirac.rather.puzzling.org>
References: <alpine.DEB.2.00.0905060004100.15177@dirac.rather.puzzling.org> <4A00DA98.5060201@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Tejun Heo wrote:

> Tim Connors wrote:
> > With 2.6.29, when I hotplug a western digital mybook into a 'Silicon
> > Image, Inc. SiI 3132 Serial ATA Raid II Controller', the drive is not
> > found:
> >
> >
> > *** drive failed due to user induced sillyness
> > ...
> > [18676.308750] sd 0:0:0:0: [sdb] Stopping disk
> > [18676.308770] sd 0:0:0:0: [sdb] START_STOP FAILED
> > [18676.308774] sd 0:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
> > *** drive plugged back in
> > [18767.821747] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xe frozen
> > [18767.821756] ata1: irq_stat 0x00b40090, PHY RDY changed
> > [18767.821775] ata1: hard resetting link
> > [18774.633185] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> > [18774.773591] ata1.00: applying link speed limit horkage to 1.5 Gbps
> > [18779.655674] ata1: hard resetting link
> > [18781.861074] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 10)
> > [18782.178565] ata1.00: configured for UDMA/100
> > [18782.178579] ata1: EH complete
> >
> > And then nothing.  The device is still alive - if I plug it back in
> > through its usb interface, it comes up normally.  I know from experience
> > that if I was to reboot the machine, it would have come up quite nicely
> > from boot:
>
> Hmm... "ata1.00: configured for UDMA/100" means libata part of
> configuration went okay but it looks like SCSI probing didn't kick in
> for reason.  Is this always reproducible?

100% of time if it is plugged in after boot.

-- 
TimC
The generation of random numbers is too important to be left to chance.
  -- Robert R. Coveyou, Oak Ridge National Laboratory.
