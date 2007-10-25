Return-Path: <linux-kernel-owner+w=401wt.eu-S1760196AbXJYLFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196AbXJYLFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbXJYLFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:05:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:7447 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754943AbXJYLFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:05:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,328,1188802800"; 
   d="scan'208";a="357970067"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] IA64/perfmon: kill dead code, clean irq handling
Date: Thu, 25 Oct 2007 04:05:18 -0700
Message-ID: <176273AE807A344A8C14F517A8FC59C20259A09E@scsmsx412.amr.corp.intel.com>
In-Reply-To: <4720592D.4030604@garzik.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] IA64/perfmon: kill dead code, clean irq handling
Thread-Index: AcgW5FDgDQDMDth6TCWQ/LRXNk5oqQADUqwg
References: <20071023230908.GA12417@havoc.gtf.org> <20071025084615.GA32656@frankl.hpl.hp.com> <4720592D.4030604@garzik.org>
From: "Villacis, Juan" <juan.villacis@intel.com>
To: "Jeff Garzik" <jeff@garzik.org>, <eranian@hpl.hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, <linux-ia64@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Stone, Joshua I" <joshua.i.stone@intel.com>
X-OriginalArrivalTime: 25 Oct 2007 11:05:22.0572 (UTC) FILETIME=[F014CCC0:01C816F6]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The VTune sampling driver currently uses this hook for cases where it
needs to do its own handling of the PMU on platforms that Perfmon2 may
not yet (fully, correctly) recognize at the time of the kernel's
release.

-juan 

-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Thursday, October 25, 2007 1:52 AM
To: eranian@hpl.hp.com
Cc: Luck, Tony; linux-ia64@vger.kernel.org; Andrew Morton; LKML; Stone,
Joshua I; Villacis, Juan
Subject: Re: [PATCH] IA64/perfmon: kill dead code, clean irq handling

Stephane Eranian wrote:
> Jeff,
> 
> On Tue, Oct 23, 2007 at 07:09:08PM -0400, Jeff Garzik wrote:
>> By deleting unused code, this makes perfmon irq handling more
efficient,
>> as well as reducing code size.
>>
>> * remove unused pfm_install_alt_pmu_interrupt()
>> * remove unused pfm_remove_alt_pmu_interrupt()
>>
> I have not problem with the patch except maybe for those two
functions.
> How do you know they are not used?
> Have you checked the VTUNE open-source driver?
> I thought at some point they were using this hook.

I was hoping some IA-64 person could speak authoritatively on the
subject :)

	Jeff
