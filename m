Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbXHQP7j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbXHQP7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:59:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750724AbXHQP7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:59:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:7619 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720AbXHQP7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:59:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,276,1183359600"; 
   d="scan'208";a="264590067"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [-mm PATCH] DMA engine kconfig improvements (rev2)
Date: Fri, 17 Aug 2007 08:59:29 -0700
Message-ID: <BAE9DCEF64577A439B3A37F36F9B691C02E18CCD@orsmsx418.amr.corp.intel.com>
In-Reply-To: <20070817004819.GB3786@stusta.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [-mm PATCH] DMA engine kconfig improvements (rev2)
Thread-Index: AcfgaFmuWCzxgCujQNOyOtqydle2tQAfvYyQ
References: <20070817001025.5634.54557.stgit@localhost.localdomain> <20070817004819.GB3786@stusta.de>
From: "Nelson, Shannon" <shannon.nelson@intel.com>
To: "Adrian Bunk" <bunk@kernel.org>
Cc: <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       "Williams, Dan J" <dan.j.williams@intel.com>, <ssatyam@cse.iitk.ac.in>
X-OriginalArrivalTime: 17 Aug 2007 15:59:30.0329 (UTC) FILETIME=[98761090:01C7E0E7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Adrian Bunk [mailto:bunk@kernel.org] 
>Sent: Thursday, August 16, 2007 5:48 PM
>To: Nelson, Shannon
>Cc: akpm@linux-foundation.org; linux-kernel@vger.kernel.org; 
>Williams, Dan J; ssatyam@cse.iitk.ac.in
>Subject: Re: [-mm PATCH] DMA engine kconfig improvements (rev2)
>
>On Thu, Aug 16, 2007 at 05:10:25PM -0700, Shannon Nelson wrote:
>> From: Adrian Bunk <bunk@stusta.de>
>> 
>> This patch contains the following changes to the DMA engine menus:
>>...
>> - make it clear in the INTEL_IOATDMA help text that this 
>driver is for
>>   rare hardware the user most likely doesn't has
>>...
>> +config INTEL_IOATDMA
>> +	tristate "Intel I/OAT DMA support"
>> +	depends on PCI && X86
>> +	select DMA_ENGINE
>> +	select DCA
>> +	help
>> +	  Enable support for the Intel(R) I/OAT DMA engine present
>> +	  in recent chipsets.
>>...
>
>It seems the string "Xeon" somehow got lost, or is it now also 
>available with other hardware?
>
>"in recent Intel Xeon chipsets"?
>
>cu
>Adrian

Good catch - however, it is probably best not to limit these things.

sln
--
======================================================================
Mr. Shannon Nelson                 LAN Access Division, Intel Corp.
Shannon.Nelson@intel.com                I don't speak for Intel
(503) 712-7659                    Parents can't afford to be squeamish.
