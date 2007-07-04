Return-Path: <linux-kernel-owner+w=401wt.eu-S1761317AbXGDLyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761317AbXGDLyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 07:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759212AbXGDLyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 07:54:13 -0400
Received: from nn7.de ([85.214.94.156]:54574 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886AbXGDLyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 07:54:12 -0400
Subject: Re: ata1: soft resetting port
From: Soeren Sonnenburg <kernel@nn7.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <4689EF48.8090506@gmail.com>
References: <1182260902.14805.60.camel@localhost>
	 <4689EF48.8090506@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Jul 2007 12:40:57 +0200
Message-Id: <1183545657.22999.15.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-03 at 15:40 +0900, Tejun Heo wrote:
> Soeren Sonnenburg wrote:
> > Dear List,
> > 
> > since the switch to 
> > 
> > CONFIG_ATA=y
> > CONFIG_ATA_ACPI=y
> > CONFIG_ATA_PIIX=y,
> > 
> > the ATA_PIIX driver manages both, internal sata disk aswell as cd/dvd
> > rom. However I am being flooded with the error messages below (well they
> > appear from time to time, dominating dmesg). 
> > 
> > This happens on kernel 2.6.22-rc5, I am copying relevant parts from dmesg:
> 
> Does 2.6.22-rc7 fare better?

Yes indeed. The only thing I've seen in the last two days was the
following on resume:

pci_express 0000:00:1c.2:pcie03: resuming
sr 0:0:0:0: resuming
sd 2:0:1:0: resuming
sd 2:0:1:0: [sda] Starting disk
ata1.00: configured for UDMA/33
ata3.01: revalidation failed (errno=-2)
ata3: failed to recover some devices, retrying in 5 secs
ata3.01: configured for UDMA/133

Soeren
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
