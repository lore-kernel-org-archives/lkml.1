Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYAZB5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYAZB5d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 20:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYAZB5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 20:57:24 -0500
Received: from mga02.intel.com ([134.134.136.20]:10932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755459AbYAZB5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 20:57:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,253,1199692800"; 
   d="scan'208";a="255208807"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in AMD Fam16 CPUs
Date: Fri, 25 Jan 2008 17:57:21 -0800
Message-ID: <2D848F959C03D945A84E9EDE7F7BFE42740228@orsmsx424.amr.corp.intel.com>
In-Reply-To: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH][RFC] SVM: Add Support for Nested Paging in AMD Fam16 CPUs
Thread-Index: AchflM3LdROw71pwSJeL47zQim9gogAKOf8A
References: <1201294393-22613-1-git-send-email-joerg.roedel@amd.com>
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Joerg Roedel" <joerg.roedel@amd.com>, "Avi Kivity" <avi@qumranet.com>,
       <kvm-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 26 Jan 2008 01:57:21.0985 (UTC) FILETIME=[CA242310:01C85FBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> Hi,
> 
> here is the first release of patches for KVM to support the Nested
Paging
> (NPT) feature of AMD QuadCore CPUs for comments and public testing.
This
> feature improves the guest performance significantly. I measured an
> improvement of around 17% using kernbench in my first tests.
> 
> This patch series is basically tested with Linux guests (32 bit legacy
> paging, 32 bit PAE paging and 64 bit Long Mode). Also tested with
Windows
> Vista 32 bit and 64 bit. All these guests ran successfully with these
> patches. The patch series only enables NPT for 64 bit Linux hosts at
the
> moment. 
> 
> Please give these patches a good and deep testing. I hope we have this
> patchset ready for merging soon.

Good. We also ported the EPT patch for Xen to KVM, which we submitted
last year. We've been cleaning up the patch with Avi. We are working on
live migration support now, and we'll submit the patch once it's done.
So please stay tuned.

> 
> Joerg
> 

Jun
---
Intel Open Source Technology Center
