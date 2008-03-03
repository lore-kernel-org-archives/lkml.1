Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYCCWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYCCWHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 17:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753572AbYCCWHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 17:07:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:58142 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYCCWHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 17:07:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,440,1199692800"; 
   d="scan'208";a="528088682"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] cpuidle: avoid singing capacitors
Date: Mon, 3 Mar 2008 14:04:06 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEA2E8B2@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080303221752.5169f91d@mjolnir.drzeus.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] cpuidle: avoid singing capacitors
Thread-Index: Ach9dJxQDSiba92tR7iLwvE/+vOVxwABLyLA
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx><20080303211842.6f492782@mjolnir.drzeus.cx><20080303204603.GA19775@elf.ucw.cz><20080303220310.0cab7213@mjolnir.drzeus.cx><20080303210839.GJ13869@elf.ucw.cz><924EFEDD5F540B4284297C4DC59F3DEEA2E81B@orsmsx423.amr.corp.intel.com> <20080303221752.5169f91d@mjolnir.drzeus.cx>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Adam Belay" <abelay@novell.com>,
       <linux-pm@lists.linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>, "Lee Revell" <rlrevell@joe-job.com>
X-OriginalArrivalTime: 03 Mar 2008 22:02:28.0643 (UTC) FILETIME=[458D4F30:01C87D7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Pierre Ossman [mailto:drzeus-list@drzeus.cx] 
>Sent: Monday, March 03, 2008 1:18 PM
>To: Pallipadi, Venkatesh
>Cc: Pavel Machek; Adam Belay; 
>linux-pm@lists.linux-foundation.org; LKML; Andi Kleen; Lee Revell
>Subject: Re: [PATCH] cpuidle: avoid singing capacitors
>
>On Mon, 3 Mar 2008 13:14:28 -0800
>"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
>
>> 
>> I prefer leaving it off my default and enabling it on faulty 
>hardware by
>> some blacklist.
>> 
>
>But are these kind of shoddy components really trackable by 
>model? I'd suspect it has more to do with the shipment of 
>parts the day when the computer was manufactured.
>

But, with this patch:
- we are penalizing good hardware and making them less power efficient
to match the bad ones.
- There may also be server systems which first may not have these sort
of power fluctuations and even when buggy and have this noise, system
may be in some corner of some lab with fans making more noise than the
capacitors.

Thanks,
Venki
