Return-Path: <linux-kernel-owner+w=401wt.eu-S1763143AbXHYAim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763143AbXHYAim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 20:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756819AbXHYAic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 20:38:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:40853 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbXHYAib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 20:38:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,305,1183359600"; 
   d="scan'208";a="267762348"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.23-rc3-mm1
Date: Fri, 24 Aug 2007 17:38:27 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5014D956A@scsmsx415.amr.corp.intel.com>
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5014D954E@scsmsx415.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.23-rc3-mm1
Thread-Index: Acfmq+bLWfekzg4sQo6w9Ws5qcOUoQAAHsvgAADIgIA=
References: <20070822020648.5ea3a612.akpm@linux-foundation.org><46CF695D.1020008@imap.cc> <20070824170702.a2c51084.akpm@linux-foundation.org> <653FFBB4508B9042B5D43DC9E18836F5014D954E@scsmsx415.amr.corp.intel.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       "Tilman Schmidt" <tilman@imap.cc>
Cc: <linux-kernel@vger.kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Andi Kleen" <ak@suse.de>,
       "Len Brown" <lenb@kernel.org>, <linux-acpi@vger.kernel.org>,
       "Dave Jones" <davej@codemonkey.org.uk>,
       "Thomas Renninger" <trenn@suse.de>, "Adam Belay" <abelay@novell.com>
X-OriginalArrivalTime: 25 Aug 2007 00:38:29.0283 (UTC) FILETIME=[419D9F30:01C7E6B0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-acpi-owner@vger.kernel.org 
>[mailto:linux-acpi-owner@vger.kernel.org] On Behalf Of 
>Pallipadi, Venkatesh
>Sent: Friday, August 24, 2007 5:14 PM
>To: Andrew Morton; Tilman Schmidt
>Cc: linux-kernel@vger.kernel.org; Thomas Gleixner; john 
>stultz; Andi Kleen; Len Brown; linux-acpi@vger.kernel.org; 
>Dave Jones; Thomas Renninger
>Subject: RE: 2.6.23-rc3-mm1
>
> 
>>> - in /var/log/warn:
>>> 
>>> Aug 25 00:44:00 xenon powersaved[5356]: WARNING 
>>(CpufreqManagement:51) No capability cpufreq_control
>>> Aug 25 00:44:00 xenon powersaved[5356]: WARNING 
>>(CpufreqManagement:51) No capability cpufreq_control
>>
>>Dunno, there're some significant-looking cpufreq changes in 
>>there, such as
>>cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be
>>-used-as-default.patch.
>>Maybe we went and chose a different governor for you?
>>
>
>This is probably not related to cpufreq changes itself. Looks 
>like it is
>coming due to
>
>>> FATAL: Error inserting processor 
>>(/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/proces
>>sor.ko): Input/output error
>>> WARNING: Error inserting processor 
>>(/lib/modules/2.6.23-rc3-mm1-testing/kernel/drivers/acpi/proces
>>sor.ko): Input/output error
>
>Not sure why this is failing though. Don't recall any significant
>changes in processor.ko recently apart from CPUIDLE stuff.
>

This is indeed related to CPUIDLE.

Tilman: Can you configure CONFIG_CPU_IDLE in your config (under Power
Management option) and double check that the frequency part works after
that.

Andrew: Adam Belay sent a recent patchset on linux-pm and linux-acpi and
one of the patches of that addresses this issue (CPUIDLE: load ACPI
properly when CPUIDLE is disabled). Those patches should come to mm soon
through acpi-test.

Thanks,
Venki
