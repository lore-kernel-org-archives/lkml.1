Return-Path: <linux-kernel-owner+w=401wt.eu-S933387AbXFRWK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933387AbXFRWK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 18:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763039AbXFRWKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 18:10:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:35111 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762815AbXFRWKs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 18:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,436,1175497200"; 
   d="scan'208";a="97788116"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
Date: Mon, 18 Jun 2007 15:10:45 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5010913F8@scsmsx415.amr.corp.intel.com>
In-Reply-To: <18748.1182203384@turing-police.cc.vt.edu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch-mm 00/25] High resolution timer updates and x86_64 support - V2
Thread-Index: Acex8qBEw95sj2eyQLaL/MHRoWbJHgAAri0A
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: <Valdis.Kletnieks@vt.edu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "LKML" <linux-kernel@vger.kernel.org>, "Andrew Morton" <akpm@osdl.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <ak@suse.de>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Arjan van de Ven" <arjan@infradead.org>
X-OriginalArrivalTime: 18 Jun 2007 22:10:46.0289 (UTC) FILETIME=[852ED010:01C7B1F5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu] 
>Sent: Monday, June 18, 2007 2:50 PM
>To: Pallipadi, Venkatesh
>Cc: Thomas Gleixner; LKML; Andrew Morton; Ingo Molnar; Andi 
>Kleen; Chris Wright; Arjan van de Ven
>Subject: Re: [patch-mm 00/25] High resolution timer updates 
>and x86_64 support - V2
>
>On Mon, 18 Jun 2007 13:24:33 PDT, "Pallipadi, Venkatesh" said:
>
>> >state2/time: -159524787
>> >state2/usage: 15007443
>> >
>> 
>> The problem is powertop only understands 
>/proc/acpi/processor/CPU*/power
>> for
>> and not /sys..cpuidle for the moment.
>> 
>> I had a patch in recent cpuidle fixes series that makes 
>/proc interface
>> active
>> again with cpuidle which should correct this. Those patches 
>are not in
>> rc4-mm2-hrt4, but are there in latest rc4-hrt and rc5-hrt series.
>
>OK, so I've got a 32/64 bug that isn't the cause of *this* 
>issue because
>powertop isn't looking at the broken value.
>

Yes. The output does indicate a bug in cpuidle /sysfs part. Will look at
sysfs output of cpuidle and fix those issues soon.

Thanks,
Venki
