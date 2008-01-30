Return-Path: <linux-kernel-owner+w=401wt.eu-S1764235AbYA3XEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764235AbYA3XEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 18:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbYA3XE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 18:04:29 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:46297 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763843AbYA3XE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 18:04:26 -0500
Date: Wed, 30 Jan 2008 23:47:11 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] net driver fixes
Message-ID: <20080130224711.GA24133@electric-eye.fr.zoreil.com>
References: <20080130094440.GA4652@havoc.gtf.org> <20080130102116.GA20846@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130102116.GA20846@uranus.ravnborg.org>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> :
[...]
> > -static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
> > +static struct pci_device_id sis190_pci_tbl[] = {
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
> >  	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
> >  	{ 0, },
> 
> The __devinitdata is OK, it is the following _devinitdata that had
> to be _devinitconst.

Strangely enough, removing the devinitdata from the sis190_pci_tbl
silents the error message here. Do you have an explanation ?

-- 
Ueimor
