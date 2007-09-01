Return-Path: <linux-kernel-owner+w=401wt.eu-S932681AbXIAWAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932681AbXIAWAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbXIAWAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:00:08 -0400
Received: from ns.suse.de ([195.135.220.2]:44127 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756164AbXIAWAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:00:06 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] x86/x86-64 PCI domain support
Date: Sun, 2 Sep 2007 00:00:03 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20070901143223.GA32216@havoc.gtf.org>
In-Reply-To: <20070901143223.GA32216@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709020000.03375.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>  
> +config PCI_DOMAINS
> +	bool "PCI domain support"
> +	depends on PCI

I don't think this should be a config option.

But there should be a pci=... option with Documentation to turn it off at runtime


> +static inline int pci_proc_domain(struct pci_bus *bus)
> +{
> +	return pci_domain_nr(bus);
> +}

The second function is redundant? 


-Andi
