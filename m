Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbXIYRY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbXIYRY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXIYRYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:24:21 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:48283 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbXIYRYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:24:21 -0400
Date: Tue, 25 Sep 2007 19:24:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oliver Pinter <oliver.pntr@gmail.com>
cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.8, pata_ali issue
In-Reply-To: <6101e8c40709251021s602f8f55id40c327ac871345f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0709251923410.945@fbirervta.pbzchgretzou.qr>
References: <20070925062115.GA18444@kroah.com> 
 <6101e8c40709250909x53b44274i17694e64dccae427@mail.gmail.com> 
 <20070925161430.GA14212@suse.de>  <Pine.LNX.4.64.0709251858520.945@fbirervta.pbzchgretzou.qr>
 <6101e8c40709251021s602f8f55id40c327ac871345f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 25 2007 19:21, Oliver Pinter wrote:
>
>the rev is locali declared:
>
>[snap]
>
> ...
>
>static void ali_init_chipset(struct pci_dev *pdev)
>{
>        u8 rev, tmp;
>        struct pci_dev *north, *isa_bridge;
>
>        pci_read_config_byte(pdev, PCI_REVISION_ID, &rev);
>
> ...
>
>[snap]
>
>what's the git id in git tree?

Huh? My top git is 4942de4a0e914f205d351a81873f4f63986bcc3c
and it has this:

static void ali_init_chipset(struct pci_dev *pdev)                              
{                                                                               
        u8 tmp;                                                                 
        struct pci_dev *north, *isa_bridge;                                     
                                                                                
        /*                                                                      
         * The chipset revision selects the driver operations and               
         * mode data.                                                           
         */                                                                     
                                                                                
        if (pdev->revision >= 0x20 && pdev->revision < 0xC2) {                  


No pci_read_config_byte here..

