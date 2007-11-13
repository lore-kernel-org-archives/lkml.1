Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbXKMXPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbXKMXPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 18:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759024AbXKMXPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 18:15:01 -0500
Received: from palrel10.hp.com ([156.153.255.245]:40311 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758081AbXKMXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 18:15:00 -0500
Date: Tue, 13 Nov 2007 16:14:58 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <greg@kroah.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Matthew Wilcox <matthew@wil.cx>,
       gregkh@suse.de, kristen.c.accardi@intel.com, lenb@kernel.org,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5][RFC] Physical PCI slot objects
Message-ID: <20071113231458.GF7541@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
	Matthew Wilcox <matthew@wil.cx>, gregkh@suse.de,
	kristen.c.accardi@intel.com, lenb@kernel.org, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
References: <20071113000853.GA13341@ldl.fc.hp.com> <20071113170129.GA20185@kroah.com> <20071113183353.GE17785@parisc-linux.org> <20071113185122.GA22536@kroah.com> <20071113211509.GB19146@auslistsprd01.us.dell.com> <20071113213108.GB7541@ldl.fc.hp.com> <20071113213646.GB4426@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113213646.GB4426@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

* Greg KH <greg@kroah.com>:
> On Tue, Nov 13, 2007 at 02:31:08PM -0700, Alex Chiang wrote:
> > 
> > FWIW, the ACPI 2.0 spec did not require uniqueness for _SUN.
> > (although there is a strange table that refers to _SUN as the
> > slot-unique ID (table 6-1 in spec v2.0b), the actual definition
> > of _SUN does not mention uniqueness).
> 
> Does your code handle if these are not unique?

I hate to punt on this, but I'm not doing anything that acpiphp
is not doing. If we get back non-unique values for _SUN, I'm
pretty sure both acpiphp and my pci_slot driver will both
continue along as far as they can, until they get an error back
from kobject_register() about trying to register an object with
an existing name.

I think I may have a machine that has non-unique values for _SUN.
If so, I'll try and hunt it down and do some testing.

Thanks for the suggestion.

/ac

