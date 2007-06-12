Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbXFLP44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbXFLP44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 11:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbXFLP4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 11:56:47 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:45788 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXFLP4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 11:56:46 -0400
Date: Tue, 12 Jun 2007 16:56:29 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>,
       Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       james.bottomley@steeleye.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20070612155629.GA14044@srcf.ucam.org>
References: <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net> <20070612153828.GA13888@srcf.ucam.org> <466EBF91.8060508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466EBF91.8060508@gmail.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 12:45:21AM +0900, Tejun Heo wrote:
> Matthew Garrett wrote:
> > Yes, but they'll also send an ACPI interrupt even if the SATA host 
> > controller doesn't - it's part of the spec for bays.
> 
> Does the spec mandate that the ACPI interrupt shouldn't depend on SATA
> phy status?  I don't think vendors are likely to implement separate
> mechanism when SATA phy status can do the job fine.

I suspect that the spec allows them to do that, but think that it's 
unlikely to actually happen in most cases. Bear in mind that Windows 
doesn't tend to drive the hardware in AHCI mode, and that their 
implementation is likely to be very similar to the implementation they 
used for PATA devices.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
