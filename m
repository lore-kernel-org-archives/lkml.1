Return-Path: <linux-kernel-owner+w=401wt.eu-S933261AbXHaS1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbXHaS1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932834AbXHaS05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:26:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:1415 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932808AbXHaS04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:26:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,193,1186383600"; 
   d="scan'208";a="286593163"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Date: Fri, 31 Aug 2007 11:26:49 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F50155E3CE@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070831182421.GA4119@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Track accurate idle time with tick_sched.idle_sleeptime
Thread-Index: Acfr/CrHM4ScgGXlS3KPoRcDaB/LyQAADUYg
References: <20070827215611.GA30396@linux-os.sc.intel.com> <20070831182212.GA3568@elte.hu> <20070831182421.GA4119@elte.hu>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 31 Aug 2007 18:26:53.0104 (UTC) FILETIME=[80F2F300:01C7EBFC]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Friday, August 31, 2007 11:24 AM
>To: Pallipadi, Venkatesh
>Cc: Thomas Gleixner; Andrew Morton; linux-kernel
>Subject: Re: [PATCH] Track accurate idle time with 
>tick_sched.idle_sleeptime
>
>
>* Ingo Molnar <mingo@elte.hu> wrote:
>
>> nice stuff! I've added your patch to the scheduler queue - but this 
>> will probably be 2.6.24 material.
>
>btw., this patch depends on the latest acpi tree, right?
>
>	Ingo

No. There are no dependencies with any ACPI changes that I know of. I
tested this patche both with latest git and mm and worked fine both
ways.

Thanks,
Venki
