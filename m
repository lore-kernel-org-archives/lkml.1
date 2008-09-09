Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYIIRSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYIIRSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 13:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYIIRSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 13:18:40 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:28786 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753782AbYIIRSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 13:18:39 -0400
Date: Tue, 9 Sep 2008 11:18:37 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, kristen.c.accardi@intel.com,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH v2 01/13] PCI Hotplug core: add 'name' param
	pci_hp_register interface
Message-ID: <20080909171837.GB4671@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org,
	kristen.c.accardi@intel.com, kaneshige.kenji@jp.fujitsu.com
References: <20080909091813.29542.85613.stgit@bob.kio> <20080909100007.29542.27510.stgit@bob.kio> <20080909120514.GU2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080909120514.GU2772@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Tue, Sep 09, 2008 at 04:00:07AM -0600, Alex Chiang wrote:
> > -extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr);
> > +extern int pci_hp_register(struct hotplug_slot *,
> > +			   struct pci_bus *,
> > +			   int nr,
> > +			   const char *name);
> 
> Not a huge fan of this style ... the usual style would be:
> 
> extern int pci_hp_register(struct hotplug_slot *, struct pci_bus *, int nr,
> 				const char *name);

Ok, will fix.

> Otherwise Acked-by: Matthew Wilcox <willy@linux.intel.com>

Thanks.

/ac

