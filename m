Return-Path: <linux-kernel-owner+w=401wt.eu-S1758162AbZBKWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162AbZBKWKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZBKWKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:10:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:38756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbZBKWKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:10:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,194,1233561600"; 
   d="scan'208";a="489243202"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>,
       "Yu, Fenghua" <fenghua.yu@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>,
       David Woodhouse <dwmw2@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Date: Thu, 12 Feb 2009 00:10:16 +0200
Subject: RE: [PATCH]iwlan dma mapping read and write changes
Thread-Topic: [PATCH]iwlan dma mapping read and write changes
Thread-Index: AcmMktofl5rEWi+eSHmBjEuWh0f/UwAAktnA
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F04F633E2FA@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
	 <1234388027.16004.50.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
	 <1234388845.16004.53.camel@johannes.local>
 <1234389007.16004.55.camel@johannes.local>
In-Reply-To: <1234389007.16004.55.camel@johannes.local>
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
>Sent: Wednesday, February 11, 2009 11:50 PM
>To: Winkler, Tomas
>Cc: Yu, Fenghua; David Woodhouse; Ingo Molnar; Stephen Rothwell; Grumbach,
>Emmanuel; Zhu, Yi; Chris Wright; LKML; iommu@lists.linux-foundation.org
>Subject: RE: [PATCH]iwlan dma mapping read and write changes
>
>On Wed, 2009-02-11 at 22:47 +0100, Johannes Berg wrote:
>> > >> Indeed the firmware/ucode write back to host memory to update retry
>> > >> counter for APMDU packets. I'm not sure if this is needed for legacy
>> > >> traffic, though.
>> > >
>> > >I don't think they can be seeing AMPDU packets since that is, well,
>> > >broken?
>> >
>> > Currently I'm not aware of any other cases where memory is accessed
>> > back but I may have not complete info.  Will be back with the answer
>> > tomorrow.
>>
>> I don't think it really matters, since AMPDU packets will be fixed soon,
>> and for those you know it's necessary (and the report says that under
>> some other circumstances it's also necessary). Unless there'd be some
>> benefit from using BIDI only when we know it'll be needed, and using
>> TODEV in the other cases?
>
>Or if there's a firmware bug.

That's why it's better to clear the picture. 
Fenghua
What exact HW do you get this error?

Thanks
Tomas 

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

