Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbZCXUhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbZCXUhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 16:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757209AbZCXUgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 16:36:51 -0400
Received: from mga11.intel.com ([192.55.52.93]:4780 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754568AbZCXUgv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 16:36:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,414,1233561600"; 
   d="scan'208";a="441696423"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Ingo Molnar'" <mingo@elte.hu>, "'Andrew Lutomirski'" <amluto@gmail.com>,
       "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Jesse Barnes'" <jbarnes@virtuousgeek.org>,
       "'Kyle McMartin'" <kyle@redhat.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "Woodhouse, David" <david.woodhouse@intel.com>,
       "'Mark Gross'" <mgross@linux.intel.com>
CC: "'LKML'" <linux-kernel@vger.kernel.org>
Date: Tue, 24 Mar 2009 13:36:46 -0700
Subject: RE: 2.6.29: can't resume from suspend with DMAR (intel iommu)
	enabled
Thread-Topic: 2.6.29: can't resume from suspend with DMAR (intel iommu)
	enabled
Thread-Index: Acmsv8Ofw6Z65nMLTjCDDF7k9ruQGAAAFT3Q
Message-ID: <A6AD88C3F2289247BE726C37303E1EB8A04DB530@orsmsx505.amr.corp.intel.com>
References: <cb0375e10903241258x32c9d0f3g35a4f56793eb8677@mail.gmail.com>
 <20090324203259.GC26930@elte.hu>
In-Reply-To: <20090324203259.GC26930@elte.hu>
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

>
>(Cc:s added)
>
>* Andrew Lutomirski <amluto@gmail.com> wrote:
>
>> On vanilla 2.6.29 (on Ubuntu 8.10), on a Lenovo x200s, my system
>> is completely hosed on resume.  It appears that even hard disk IO
>> didn't work (trying to do *anything* including getting a dmesg
>> trace just spewed sda io errors to the console).  Hence no trace.
>> I did an alt-sysrq-b and the screen went blank and the machine
>> just started beeping at me.
>>
>> Resume works much better with intel_iommu=off.  (I remember seeing
>> a patch go by that purported to fix resume with IOMMU enabled, but
>> it didn't work for me.)
>>
>> I'd be happy to try to make a better bug report if anyone has any
>> bright ideas.
>
>i have a Lenovo T500 that does not even boot with with DMAR enabled
>in the BIOS (it's default-off), i get this panic in early bootup:
>
>    DMAR hardware is malfunctioning
>
>So i dont get to test suspend/resume ;-)
>
Current kernel doesn't have iommu suspend/resume support yet. I'll send out suspend/resume patches today or tomorrow. Hope that will help.

Thanks.

-Fenghua
