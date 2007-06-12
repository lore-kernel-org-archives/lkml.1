Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbXFLP6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbXFLP6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbXFLP6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:58:40 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45805 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbXFLP6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:58:38 -0400
Date: Tue, 12 Jun 2007 16:58:24 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       htejun@gmail.com
Message-ID: <20070612155824.GB14044@srcf.ucam.org>
References: <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net> <20070612153828.GA13888@srcf.ucam.org> <466EBFF0.70100@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466EBFF0.70100@garzik.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:46:56AM -0400, Jeff Garzik wrote:
> Matthew Garrett wrote:
> >On Tue, Jun 12, 2007 at 11:17:14AM -0300, Henrique de Moraes Holschuh 
> >wrote:
> >>On Tue, 12 Jun 2007, Matthew Garrett wrote:
> >>>Laptop bays are designed to deal with hotplugging PATA - I don't think 
> >>>this is too much of an issue :)
> >>The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
> >>cards use usb2.0 and pci-e hotplug...
> >
> >Yes, but they'll also send an ACPI interrupt even if the SATA host 
> >controller doesn't - it's part of the spec for bays.
> 
> Regardless, having a laptop does not imply having a docking bay.

Excluding the corner case of an Expresscard SATA controller (where I 
suspect you'd want different policy), I doubt there are any cases where 
you have a laptop with hotplug capabilities without it being implemented 
as an ACPI bay.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
