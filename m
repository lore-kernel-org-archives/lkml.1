Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXINWkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXINWkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 18:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbXINWkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 18:40:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:52566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757031AbXINWkb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 18:40:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,257,1186383600"; 
   d="scan'208";a="307249833"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Date: Fri, 14 Sep 2007 15:40:29 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46EB0657.40603@codemonkey.ws>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Thread-Index: Acf3G82DqlLKz2UnQxi+hI0c6pvbRQAAEUog
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Anthony Liguori" <anthony@codemonkey.ws>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>
X-OriginalArrivalTime: 14 Sep 2007 22:40:30.0353 (UTC) FILETIME=[40EB6010:01C7F720]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Jeremy Fitzhardinge wrote:
> > Anthony Liguori wrote:
> > 
> > > Yeah, see, the initial goal was to make it possible to use the KVM
> > > paravirtualizations on other hypervisors.  However, I don't think
this
> > > is really going to be possible in general so maybe it's better to
just
> > > use leaf 0.  I'll let others chime in before sending a new patch.
> > > 
> > 
> > Hm.  Obviously you can just define a signature for "kvm-compatible
> > hypercall interface" and make it common that way, but it gets tricky
if
> > the hypervisor supports multiple hypercall interfaces, including the
kvm
> > one.  Start the kvm leaves at 0x40001000 or something?
> > 
> 
> Yeah, that works with me.

To me this is the beginning of fragmentation. Why do we need different
and VMM-specific Linux paravirtualization for hardware-assisted
virtualization? That would not be good for Linux.

> 
> Regards,
> 
> Anthony Liguori
> 
> >     J

Jun
---
Intel Open Source Technology Center
