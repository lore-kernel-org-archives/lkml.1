Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXC3Ngu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXC3Ngu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 09:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbXC3Ngu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 09:36:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:41354 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbXC3Ngt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 09:36:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,353,1170662400"; 
   d="scan'208"; a="219231119:sNHT19917940"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/5] RT kernel: force detect HPET from PCI space
Date: Fri, 30 Mar 2007 06:36:46 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F52DF55E@scsmsx415.amr.corp.intel.com>
In-Reply-To: <1175248003.6157.43.camel@earth4>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/5] RT kernel: force detect HPET from PCI space
thread-index: AcdysFWHRmNGhITvRWmayqsPvHnytwAH9z6Q
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@redhat.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
X-OriginalArrivalTime: 30 Mar 2007 13:36:47.0537 (UTC) FILETIME=[76CEB210:01C772D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@redhat.com] 
>Sent: Friday, March 30, 2007 2:47 AM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel; Thomas Gleixner
>Subject: Re: [PATCH 1/5] RT kernel: force detect HPET from PCI space
>
>On Thu, 2007-02-22 at 17:06 -0800, Venkatesh Pallipadi wrote:
>> Patchset enables force detection of HPET, when it is not listed by
>> BIOS.
>> and enables use of HPET as a event source. HPET timers
>> configures in stamdard interrupt mode can be used as dependable per
>> CPU timer
>> on laptops that are known to have LAPIC stoppage with ACPI C3 state.
>
>(sorry about the belated reply)
>
>cool patchset! I suspect the most logical place to start this would be
>on upstream 32-bit, which has the hpet clockevents changes already.
>Plus the i386 and x86_64 hpet code should be unified.
>

Yes. I restarted the work recently with i386 and upstream. I should
have the some patches in couple of weeks time.

Thanks,
Venki
