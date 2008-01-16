Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYAPWNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYAPWNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYAPWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:13:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:41968 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbYAPWNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:13:44 -0500
X-ExtLoop1: 1
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Date: Wed, 16 Jan 2008 14:14:40 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5E8C86@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080116220153.GA39717@muc.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
Thread-Index: AchYi2q/EIgt+k4MSQ6yN9tlr8WhSgAAZhsg
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080116220153.GA39717@muc.de>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andi Kleen" <ak@muc.de>
Cc: "Andreas Herrmann" <andreas.herrmann3@amd.com>, <ebiederm@xmission.com>,
       <rdreier@cisco.com>, <torvalds@linux-foundation.org>, <gregkh@suse.de>,
       <airlied@skynet.ie>, <davej@redhat.com>, <mingo@elte.hu>,
       <tglx@linutronix.de>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
       <arjan@infradead.org>, "Barnes, Jesse" <jesse.barnes@intel.com>,
       <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
X-OriginalArrivalTime: 16 Jan 2008 22:13:43.0597 (UTC) FILETIME=[0E70DDD0:01C8588D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Andi Kleen [mailto:ak@muc.de] 
>Sent: Wednesday, January 16, 2008 2:02 PM
>To: Pallipadi, Venkatesh
>Cc: Andreas Herrmann; ebiederm@xmission.com; 
>rdreier@cisco.com; torvalds@linux-foundation.org; 
>gregkh@suse.de; airlied@skynet.ie; davej@redhat.com; 
>mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
>akpm@linux-foundation.org; arjan@infradead.org; Barnes, Jesse; 
>davem@davemloft.net; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 0/4] x86: PAT followup - Incremental 
>changes and bug fixes
>
>> This ioremap failing seems to be the real problem. This can be due to
>> new tracking of ioremaps introduced by PAT patches. We do not allow
>> conflicting ioremaps to same region. Probably that is happening
>
>Normally if there is a conflict there should be a printk (or 
>at least it was
>so in the original mattr code if you haven't changed it)
>

Yes. Printks are there. But are with KERN_DEBUG now. We should change
them to WARNING atleast.

Thanks,
Venki
