Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbYIJWlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbYIJWlv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYIJWlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:41:42 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:30442 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbYIJWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:41:41 -0400
Date: Wed, 10 Sep 2008 16:41:30 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 3/4 v2] PCI: support SR-IOV capability
Message-ID: <20080910224130.GC16740@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6F@pdsmsx414.ccr.corp.intel.com> <20080901164104.GG16796@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110181CB1A@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110181CB1A@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> On Tuesday, September 02, 2008 12:41 AM, Alex Chiang wrote:
> >
> >So, what happens if another hotplug driver is already loaded?
> >
> >I don't know the SR-IOV spec well enough to know if you are
> >allowed to have SR-IOV + some other form of hotplug, like ACPI or
> >native PCIe.
> >
> >Today, pci_hp_register will return -EBUSY.
> >
> >If SR-IOV really doesn't have anything to do with hotplug, then
> >it may be a candidate for directly calling pci_create_slot(). In
> >that case, 'param' should not be a property of a hotplug slot,
> >but of a generic PCI slot.
> 
> That's correct, SR-IOV really doesn't have anything to do with
> hotplug. I was just reusing hotplug sysfs as the control
> interface. Will remove this in next work, and create SR-IOV own
> sysfs entries under /sys/bus/pci/devices/.../iov/...

That sounds like a much better idea to me, thanks.

/ac

