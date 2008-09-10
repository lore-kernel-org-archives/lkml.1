Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYIJHsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYIJHsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbYIJHsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:48:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:62753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbYIJHsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:48:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,371,1217833200"; 
   d="scan'208";a="614711608"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 2/4 v2] PCI: support ARI capability
Date: Wed, 10 Sep 2008 15:48:04 +0800
Message-ID: <7A25B56E4BE99C4283EB931CD1A40E110181CAF7@pdsmsx414.ccr.corp.intel.com>
In-Reply-To: <ada3akjj268.fsf@cisco.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2/4 v2] PCI: support ARI capability
Thread-Index: AckMSnZjgfdQe9cqRUOUN5Z9zGpSOwGzY76A
References: <7A25B56E4BE99C4283EB931CD1A40E110177EB6E@pdsmsx414.ccr.corp.intel.com><20080901152734.GC16796@ldl.fc.hp.com> <ada3akjj268.fsf@cisco.com>
From: "Zhao, Yu" <yu.zhao@intel.com>
To: "Roland Dreier" <rdreier@cisco.com>, "Alex Chiang" <achiang@hp.com>
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, <linux-pci@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Greg KH" <greg@kroah.com>,
       "Grant Grundler" <grundler@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, <linux-kernel@vger.kernel.org>,
       <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
       <xen-devel@lists.xensource.com>
X-OriginalArrivalTime: 10 Sep 2008 07:48:15.0893 (UTC) FILETIME=[956E8C50:01C91319]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 01, 2008 11:50 PM, Roland Dreier wrote:
>To: Alex Chiang
>Cc: Zhao, Yu; Jesse Barnes; linux-pci@vger.kernel.org; Randy Dunlap; Greg KH;
>Grant Grundler; Matthew Wilcox; linux-kernel@vger.kernel.org;
>kvm@vger.kernel.org; virtualization@lists.linux-foundation.org;
>xen-devel@lists.xensource.com
>Subject: Re: [PATCH 2/4 v2] PCI: support ARI capability
>
> > > +config PCI_ARI
> > > +	bool "PCI ARI support"
> > > +	depends on PCI
> > > +	default n
> > > +	help
> > > +	  This enables PCI Alternative Routing-ID Interpretation.
> >
> > This Kconfig help text is a little weak. Why not include the text
> > you've already written here:
> >
> > 	Support Alternative Routing-ID Interpretation (ARI), which
> > 	increases the number of functions that can be supported by a PCIe
> > 	endpoint. ARI is required by SR-IOV.
>
>I agree with this improvement to the help text.  But a further question
>is whether ARI even merits its own user-visible config option.  Is it
>worth having yet another choice for users?  When would someone want ARI
>but not SR-IOV?

ARI is an independent PCI Express extended capability. Multi-function devices supporting this capability may use it to track dependency between different functions and assign function group numbers to these functions.

Another reason to keep this separated with SR-IOV is that after ARI is enabled, PCI Express Endpoint may have non-zero slot number (device number), which is different from traditional PCI Express Endpoint.

Thanks.

>
> - R.

