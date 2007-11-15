Return-Path: <linux-kernel-owner+w=401wt.eu-S1765235AbXKORkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765235AbXKORkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758343AbXKORkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:40:20 -0500
Received: from palrel13.hp.com ([156.153.255.238]:52046 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758284AbXKORkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:40:18 -0500
Date: Thu, 15 Nov 2007 10:40:15 -0700
From: Alex Chiang <achiang@hp.com>
To: Rolf Eike Beer <eike-hotplug@sf-tec.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
       Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/5] Construct one fakephp slot per pci slot
Message-ID: <20071115174015.GI7541@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Rolf Eike Beer <eike-hotplug@sf-tec.de>,
	Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
	Greg KH <greg@kroah.com>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	kaneshige.kenji@jp.fujitsu.com, pcihpd-discuss@lists.sourceforge.net,
	linux-acpi@vger.kernel.org
References: <20071114193605.GA25002@ldl.fc.hp.com> <20071114201246.GZ17785@parisc-linux.org> <20071114205555.GH25002@ldl.fc.hp.com> <200711151258.02696.eike-hotplug@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711151258.02696.eike-hotplug@sf-tec.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Rolf Eike Beer <eike-hotplug@sf-tec.de>:
> Am Mittwoch, 14. November 2007 schrieb Alex Chiang:
> > * Matthew Wilcox <matthew@wil.cx>:
> > > On Wed, Nov 14, 2007 at 12:37:29PM -0700, Alex Chiang
> > > > Register one slot per slot, rather than one slot per
> > > > function.  Change the name of the slot to fake%d instead
> > > > of the pci address.
> > > >
> > > > +#define SLOT_NAME_SIZE KOBJ_NAME_LEN
> > >
> > > Defined, then never used ... how about s/KOBJ_NAME_LEN/8/,
> > > then use SLOT_NAME_SIZE throughout?
> >
> > Whoops, good catch. I had a braino there.
> 
> Just drop it and use sizeof(dslot->name) in snprintf(). Just be
> careful not to use slot->name there as it would always be
> sizeof(void*)!

Thanks, even better.

/ac

