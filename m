Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbYIJWip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbYIJWip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:38:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYIJWig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:38:36 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:19825 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYIJWif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:38:35 -0400
Date: Wed, 10 Sep 2008 16:37:11 -0600
From: Alex Chiang <achiang@hp.com>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Subject: Re: [PATCH 1/4 v2] PCI: introduce new base functions
Message-ID: <20080910223711.GA16740@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	"Zhao, Yu" <yu.zhao@intel.com>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
	Grant Grundler <grundler@parisc-linux.org>,
	Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	xen-devel@lists.xensource.com
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6D@pdsmsx414.ccr.corp.intel.com> <20080901161534.GF16796@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110181CB4E@pdsmsx414.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7A25B56E4BE99C4283EB931CD1A40E110181CB4E@pdsmsx414.ccr.corp.intel.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Zhao, Yu <yu.zhao@intel.com>:
> 
> It can be PCI_BRIDGE_RESOURCES, because there may be some
> non-standard resources following PCI_ROM_RESOURCE and before
> PCI_BRIDGE_RESOURCES.
> 
> For example, a standard PCI device has following resources:
> 	0 - 5   BARs
> 	6       ROM
> 	7 - 10  Bridge
> 
> After SR-IOV is enabled, it becomes
> 	0 - 5   standard BARs
> 	6       Rom
>      7 - 12  SR-IOV BARs
> 	13 - 16 Bridge

Ok, makes sense now; was that documented somewhere else, and I
just missed it?

> Same as above, the PCI_BRIDGE_RES_END varies when some features
> is enabled or disabled.

Ok, I must have missed this documentation too.

> Thank you very much for carefully reviewing these patches. I'd
> like to invite you to review next version again if it's
> convenient for you.

Sure, you can Cc me next time too.

Thanks.

/ac

