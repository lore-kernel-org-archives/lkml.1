Return-Path: <linux-kernel-owner+w=401wt.eu-S1757616AbZBKVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616AbZBKVlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZBKVlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:41:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:26465 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZBKVlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:41:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,194,1233561600"; 
   d="scan'208";a="430227647"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.sc.intel.com>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Date: Wed, 11 Feb 2009 23:41:38 +0200
Subject: RE: [PATCH]iwlan dma mapping read and write changes
Thread-Topic: [PATCH]iwlan dma mapping read and write changes
Thread-Index: AcmMkIsLTGiPZfKPRVilrwazwaQNGwAACcsA
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
 <1234388027.16004.50.camel@johannes.local>
In-Reply-To: <1234388027.16004.50.camel@johannes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Johannes Berg [mailto:johannes@sipsolutions.net]
>Sent: Wednesday, February 11, 2009 11:34 PM
>To: Winkler, Tomas
>Cc: Yu, Fenghua; David Woodhouse; Ingo Molnar; Stephen Rothwell; Andrew
>Morton; Grumbach, Emmanuel; Zhu, Yi; Chris Wright; LKML; iommu@lists.linux-
>foundation.org
>Subject: RE: [PATCH]iwlan dma mapping read and write changes
>
>On Wed, 2009-02-11 at 23:27 +0200, Winkler, Tomas wrote:
>
>> >mapping with PCI_DMA_TODEVICE which is read only in mapping PTE. But
>iwlan
>> >device
>> >actually writes to the mapped page to update its contents. This issue is
>> >not
>> >exposed in swiotlb. But VT-d hardware can capture this fault and stop
>the
>> >fault
>> >transaction.
>> >
>> >The following patch fixes the issue.
>> >
>> >Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
>> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
>>
>> Indeed the firmware/ucode write back to host memory to update retry
>> counter for APMDU packets. I'm not sure if this is needed for legacy
>> traffic, though.
>
>I don't think they can be seeing AMPDU packets since that is, well,
>broken?

Currently I'm not aware of any other cases where memory is accessed back but I may have not complete info.  Will be back with the answer tomorrow.
Tomas 

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

