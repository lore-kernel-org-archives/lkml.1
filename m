Return-Path: <linux-kernel-owner+w=401wt.eu-S965574AbXDIVUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574AbXDIVUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965578AbXDIVUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:20:22 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45340 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965574AbXDIVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:20:20 -0400
Date: Mon, 9 Apr 2007 22:22:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@canonical.com
Subject: Re: [PATCH] HPA support: Revised patch
Message-ID: <20070409222241.6581ecc2@the-village.bc.nu>
In-Reply-To: <20070406163707.GA25880@srcf.ucam.org>
References: <20070405141352.12fddb6e@the-village.bc.nu>
	<20070406163707.GA25880@srcf.ucam.org>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2007 17:37:07 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, Apr 05, 2007 at 02:13:52PM +0100, Alan Cox wrote:
> > This one should fix the problems with slave devices and the Macintosh hang
> 
> Better, but still not happy with ata_piix - I get the following:
> 
> [   10.972000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = 16337840
> [   10.972000] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
> [   10.972000] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
> [   10.980000] ata3.01: ata_hpa_resize 1: sectors = 234441648, hpa_sectors = -1342616656
> [   10.980000] ata3.01: Host Protected Area detected:
> [   10.980000] 	current size: 234441648 sectors
> [   10.980000] 	native size: -1342616656 sectors
>                              ^^^^^^^^^^^!?!?!?!?!?!?!?
> 
> so I'm not especially keen on letting it reprogram stuff. With ahci it 
> works fine. Still on a Macbook Pro - fuller logs below.

Please apply Tejun's fix for LBA48 data and try again. Hopefully its just
that which is causing the problem.

Alan
