Return-Path: <linux-kernel-owner+w=401wt.eu-S1758336AbZDJXVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336AbZDJXVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 19:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZDJXVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 19:21:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:55099 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZDJXVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 19:21:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,169,1239001200"; 
   d="scan'208";a="446959904"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Kyle McMartin'" <kyle@redhat.com>
CC: "'Ingo Molnar'" <mingo@elte.hu>, "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Mark Gross'" <mgross@linux.intel.com>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Apr 2009 16:21:02 -0700
Subject: RE: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
Thread-Topic: 2.6.29: can't resume from suspend with DMAR (intel iommu)
 enabled
Thread-Index: Acm6Ll/zllZMzOL+Ruyc7d+3QUYQ8wAAI5NA
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8A0AE5B13@orsmsx505.amr.corp.intel.com>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
	 <20090324203259.GC26930@elte.hu>
	 <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
	 <20090324204028.GE11771@kibblesnbits.boston.devel.redhat.com>
 <1239403571.712.1228.camel@macbook.infradead.org>
In-Reply-To: <1239403571.712.1228.camel@macbook.infradead.org>
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

>-----Original Message-----
>From: David Woodhouse [mailto:dwmw2@infradead.org]
>Sent: Friday, April 10, 2009 3:46 PM
>To: Kyle McMartin
>Cc: Yu, Fenghua; 'Ingo Molnar'; 'Andrew Lutomirski'; 'Jesse Barnes';
>Siddha, Suresh B; 'Yinghai Lu'; 'Mark Gross'; 'LKML'
>Subject: Re: 2.6.29: can't resume from suspend with DMAR (intel iommu)
>enabled
>
>On Tue, 2009-03-24 at 16:40 -0400, Kyle McMartin wrote:
>> > Current kernel doesn't have iommu suspend/resume support yet. I'll
>> > send out suspend/resume patches today or tomorrow. Hope that will
>> > help.
>>
>> Heh, awesome, someone could have brought this, uhm, subtle, weakness
>> when things were getting defaulted on...
>
>git://git.infradead.org/~dwmw2/iommu-suspend-2.6.29.git
>
>That's just for IOMMU, not interrupt remapping (yet).
>

Intr remapping needs to be pack ported to 2.6.29 from kernel git tree.

Thanks.

-Fenghua
