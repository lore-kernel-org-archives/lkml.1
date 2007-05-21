Return-Path: <linux-kernel-owner+w=401wt.eu-S1764220AbXEUPwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764220AbXEUPwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:52:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXEUPwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:52:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:47010 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956AbXEUPwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:52:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,561,1170662400"; 
   d="scan'208";a="230398464"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 4/8] Force detect and enable HPET on ICH
Date: Mon, 21 May 2007 08:52:34 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5EA4C09@scsmsx415.amr.corp.intel.com>
In-Reply-To: <200705210846.03540.jbarnes@virtuousgeek.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 4/8] Force detect and enable HPET on ICH
Thread-Index: Acebvy1jsQ2vNtHQSIa85EPuy6M/EAAAHQfw
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <ak@suse.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Chris Wright" <chrisw@sous-sol.org>
X-OriginalArrivalTime: 21 May 2007 15:52:36.0588 (UTC) FILETIME=[0D8032C0:01C79BC0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Jesse Barnes [mailto:jbarnes@virtuousgeek.org] 
>Sent: Monday, May 21, 2007 8:46 AM
>To: Udo A. Steinberg
>Cc: Pallipadi, Venkatesh; linux-kernel; Andrew Morton; Thomas 
>Gleixner; Andi Kleen; Ingo Molnar; Chris Wright
>Subject: Re: [PATCH 4/8] Force detect and enable HPET on ICH
>
>On Sunday, May 20, 2007, Udo A. Steinberg wrote:
>> On Mon, 7 May 2007 13:31:28 -0700 Venki Pallipadi (VP) wrote:
>>
>> VP> Force detect and/or enable HPET on ICH chipsets. This patch just
>> handles the VP> detection part and following patches use this
>> information.
>> VP>
>> VP> Signed-off-by: Venkatesh Pallipadi 
><venkatesh.pallipadi@intel.com>
>>
>> Venki,
>>
>> Is there any reason your patch only enables HPET on ICH6 and beyond?
>> HPET can be enabled on earlier ICH by setting bit 17 in 
>GEN_CNTL on PCI
>> dev 31, func 0, offset d0. This seems to work for ICH3/4/5. Are there
>> any errata affecting these ICHs?
>
>I see it documented in the ICH5 datasheet, but that bit is 
>marked reserved 
>in the ICH3 and ICH4 datasheets...  Which docs are you looking at?
>
>Jesse

The same bits are supported on ICH5 and ICH4M. I am about to
send a patch to add PCIIDs of ICH5 and ICH4M to force_detect. 

These bits were reserved on ICH4 though.

Thanks,
Venki
