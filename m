Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbYLKBL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbYLKBL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 20:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbYLKBLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 20:11:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:35279 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYLKBLp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 20:11:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,749,1220252400"; 
   d="scan'208";a="413394097"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Joerg Roedel'" <joerg.roedel@amd.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>
CC: "'Avi Kivity'" <avi@redhat.com>, "'mingo@redhat.com'" <mingo@redhat.com>,
       "'torvalds@linux-foundation.org'" <torvalds@linux-foundation.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Date: Thu, 11 Dec 2008 09:11:21 +0800
Subject: RE: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Thread-Topic: [PATCHSETS #2] KVM device passthrough support with AMD IOMMU
Thread-Index: Acla0z4qBZZ0fCqVQ7a70Oype6ZivQAWgUWA
Message-ID: <715D42877B251141A38726ABF5CABF2C018E6FAE6E@pdsmsx503.ccr.corp.intel.com>
References: <20081209141143.GW12816@amd.com> <493F8D90.40205@redhat.com>
 <20081210141131.GB12816@amd.com>
 <1228918928.21454.27.camel@macbook.infradead.org>
 <20081210142525.GC12816@amd.com>
In-Reply-To: <20081210142525.GC12816@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Wed, Dec 10, 2008 at 02:22:08PM +0000, David Woodhouse wrote:
>> On Wed, 2008-12-10 at 15:11 +0100, Joerg Roedel wrote:
>>> So now its open how this will be merged alltogether. We can merge
>>> it in three steps (first from Dave's tree, then Avi and at last my
>>> IOMMU updates which has to happen in that order).
>>> The other option is to merge this all with one pull-request I send
>>> to Linus. It should not conflict with your updates Avi because all
>>> these changes apply also cleanly to current linus/master.
>>> Is this acceptable for everyone?
>>> 
>>> David, its important to hear your opinion on that because this
>>> single pull-request would include all VT-d updates you have queued
>>> in your tree? Is this ok for you?
>> 
>> Yes, that's fine by me. Should I apply patches 1-14 of Weidong's
>> patch set from Monday first? Or just let you do that?
> 
> I already did it on-top of your tree because Han Weidong's patches
> 1-17 were rebased to your tree and my IOMMU-API patches apply on-top
> of his patches.
> 
> Joerg

It's good. Thanks Dave and Joerg.

Regards,
Weidong