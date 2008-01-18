Return-Path: <linux-kernel-owner+w=401wt.eu-S1763133AbYARRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133AbYARRM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:12:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760299AbYARRMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:12:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:7666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759854AbYARRMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:12:14 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Date: Fri, 18 Jan 2008 09:13:10 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE62B6BE@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080118161057.GB4636@alberich.amd.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Thread-Index: AchZ7LhtywMcUYz0RKu3m/HOifXYQwACHZmQ
References: <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com> <20080117214209.GA12811@elte.hu> <20080117220650.GE12631@alberich.amd.com> <20080117221505.GB18883@elte.hu> <20080117225243.GH12631@alberich.amd.com> <20080117230410.GA8694@linux-os.sc.intel.com> <20080118161057.GB4636@alberich.amd.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andreas Herrmann3" <andreas.herrmann3@amd.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <ak@muc.de>,
       <ebiederm@xmission.com>, <rdreier@cisco.com>,
       <torvalds@linux-foundation.org>, <gregkh@suse.de>, <airlied@skynet.ie>,
       <davej@redhat.com>, <tglx@linutronix.de>, <hpa@zytor.com>,
       <akpm@linux-foundation.org>, <arjan@infradead.org>,
       "Barnes, Jesse" <jesse.barnes@intel.com>, <davem@davemloft.net>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Jan 2008 17:12:13.0039 (UTC) FILETIME=[447447F0:01C859F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andreas Herrmann3 [mailto:andreas.herrmann3@amd.com] 
>Sent: Friday, January 18, 2008 8:11 AM
>To: Pallipadi, Venkatesh
>Cc: Ingo Molnar; Siddha, Suresh B; ak@muc.de; 
>ebiederm@xmission.com; rdreier@cisco.com; 
>torvalds@linux-foundation.org; gregkh@suse.de; 
>airlied@skynet.ie; davej@redhat.com; tglx@linutronix.de; 
>hpa@zytor.com; akpm@linux-foundation.org; arjan@infradead.org; 
>Barnes, Jesse; davem@davemloft.net; linux-kernel@vger.kernel.org
>Subject: Re: [patch 0/4] x86: PAT followup - Incremental 
>changes and bug fixes
>
>On Thu, Jan 17, 2008 at 03:04:10PM -0800, Venki Pallipadi wrote:
>>
>> Below is another potential fix for the problem here. Going 
>through ACPI
>> ioremap usages, we found at one place the mapping is cached 
>for possible
>> optimization reason and not unmapped later. Patch below always unmaps
>> ioremap at this place in ACPICA.
>
>The patch does not fix the problem. The conflicting cache 
>attributes are
>still there.
>

Andreas,

Could you also try the patch Suresh Siddha sent out yesterday. That
covers the case where the attribute was not getting removed even after
unmap was called.

Thanks,
Venki
