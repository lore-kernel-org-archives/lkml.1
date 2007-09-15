Return-Path: <linux-kernel-owner+w=401wt.eu-S932542AbXIOBEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542AbXIOBEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 21:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932110AbXIOBES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 21:04:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:38054 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759525AbXIOBER convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 21:04:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,257,1186383600"; 
   d="scan'208";a="295183589"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Date: Fri, 14 Sep 2007 18:04:07 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE10379ED4C@scsmsx412.amr.corp.intel.com>
In-Reply-To: <46EB2716.1070908@goop.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH] Refactor hypercall infrastructure
Thread-Index: Acf3L0ps6Hsc889QRQKRzW7chCuKuQAAqPkA
References: <11897991353793-git-send-email-aliguori@us.ibm.com><46EAF4C6.8090903@goop.org> <46EAF6FC.80207@codemonkey.ws><46EAFBA0.4020503@goop.org> <46EB0136.6080105@codemonkey.ws><46EB02BA.6030909@goop.org> <46EB0657.40603@codemonkey.ws> <97D612E30E1F88419025B06CB4CF1BE10379EBF9@scsmsx412.amr.corp.intel.com> <46EB1285.5050807@goop.org> <97D612E30E1F88419025B06CB4CF1BE10379ED0A@scsmsx412.amr.corp.intel.com> <46EB2716.1070908@goop.org>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Anthony Liguori" <anthony@codemonkey.ws>,
       <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       "Avi Kivity" <avi@qumranet.com>
X-OriginalArrivalTime: 15 Sep 2007 01:04:15.0866 (UTC) FILETIME=[562035A0:01C7F734]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Nakajima, Jun wrote:
> > Today, 3 CPUID leaves starting from 0x4000_0000 are defined in a
generic
> > fashion (hypervisor detection, version, and hypercall page), and
those
> > are the ones used by Xen today. We should extend those leaves (e.g.
> > starting from 0x4000_0003) for the vmm-independent features as well.
> > 
> > If Xen needs additional Xen-specific features, we need to allocate
some
> > leaves for those (e.g. 0x4000_1000)
> 
> But the signature is "XenVMMXenVMM", which isn't very generic.  If
we're
> presenting a generic interface, it needs to have a generic signature,
> otherwise guests will need to have a list of all hypervisor signatures
> supporting their interface.  Since 0x40000000 has already been
> established as the base leaf of the hypervisor-specific interfaces,
the
> generic interface will have to be elsewhere.

The hypervisor detection machanism is generic, and the signature
returned is implentation specific. Having a list of all hypervisor
signatures sounds fine to me as we are detecting vendor-specific
processor(s) in the native. And I don't expect the list is large. 

> 
>     J

Jun
---
Intel Open Source Technology Center
