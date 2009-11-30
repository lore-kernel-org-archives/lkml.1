Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613AbZK3VoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbZK3VoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 16:44:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZK3VoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 16:44:04 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:29588 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbZK3VoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 16:44:03 -0500
Subject: Re: [PATCH] PCI: Always set prefetchable base/limit upper32
 registers
From: Alex Williamson <alex.williamson@hp.com>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: jbarnes@virtuousgeek.org, yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091130214243.GA24539@lackof.org>
References: <20091130212228.7555.43533.stgit@debian.lart>
	 <20091130214243.GA24539@lackof.org>
Content-Type: text/plain; charset="UTF-8"
Organization: HP OSLO R&D
Date: Mon, 30 Nov 2009 14:43:57 -0700
Message-ID: <1259617437.8949.282.camel@8530w.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 14:42 -0700, Grant Grundler wrote:
> On Mon, Nov 30, 2009 at 02:22:53PM -0700, Alex Williamson wrote:
> > diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> > index cb1a027..127d759 100644
> > --- a/drivers/pci/setup-bus.c
> > +++ b/drivers/pci/setup-bus.c
> > @@ -221,11 +221,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
> >  	}
> >  	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
> >  
> > -	if (pref_mem64) {
> > -		/* Set the upper 32 bits of PREF base & limit. */
> > -		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> > -		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> > -	}
> 
> Why not remove all references to pref_mem64?
> This was the only use AFAICT.

Ah, good point, I'll send a v2.  Thanks Grant.

Alex

