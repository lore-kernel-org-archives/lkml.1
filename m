Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbXEXXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbXEXXNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXEXXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:13:13 -0400
Received: from mga03.intel.com ([143.182.124.21]:59657 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759AbXEXXNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:13:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="231853457"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Date: Thu, 24 May 2007 16:13:04 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5EE129C@scsmsx415.amr.corp.intel.com>
In-Reply-To: <465619CE.9000406@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Thread-Index: AceeV8w7QTzjs3EqTqKOfHXgoO3/yQAALlkQ
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andi Kleen" <ak@suse.de>, "Dave Jones" <davej@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 May 2007 23:13:05.0832 (UTC) FILETIME=[15CC0A80:01C79E59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Thursday, May 24, 2007 4:04 PM
>To: Pallipadi, Venkatesh
>Cc: Andi Kleen; Dave Jones; Andrew Morton; Brown, Len; linux-kernel
>Subject: Re: [PATCH] Display Intel Dynamic Acceleration 
>feature in /proc/cpuinfo
>
>Venki Pallipadi wrote:
>> 
>> I can do it in intel setup function. But, the feature may 
>not be activated
>> unless the driver is loaded. Going by the hardware capability point
>> of view, we can do it in setup function.
>> 
>> The feature appears in CPUID 6 (called Power Management 
>Leaf) instead of
>> regular CPUID 1 features.
>> 
>
>This sounds like it should be a new CPUID word?
>

Yes. But it only has 3 features defined right now. 2 in EAX and one in
ECX. Should I use 2 new words for these bits or just use the software
defined bits as in my earlier patch?

Thanks,
Venki 
