Return-Path: <linux-kernel-owner+w=401wt.eu-S1756646AbYCMRA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbYCMRA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 13:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754245AbYCMRAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 13:00:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:61091 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbYCMRAs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 13:00:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,495,1199692800"; 
   d="scan'208";a="218229135"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Date: Thu, 13 Mar 2008 09:47:30 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEEB33CDD@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080313173437.5f00f70e@mjolnir.drzeus.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Thread-Index: AciFKHfZy/8woBidSAyYrG8Kdr6/IwAAQ1DA
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org><20080310100008.GA9520@elf.ucw.cz><20080310134915.45ae7446@mjolnir.drzeus.cx><200803121511.17389.lenb@kernel.org> <20080313173437.5f00f70e@mjolnir.drzeus.cx>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Pierre Ossman" <drzeus-list@drzeus.cx>, "Len Brown" <lenb@kernel.org>
Cc: <linux-pm@lists.linux-foundation.org>, "Pavel Machek" <pavel@ucw.cz>,
       "LKML" <linux-kernel@vger.kernel.org>, "Adam Belay" <abelay@novell.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Lee Revell" <rlrevell@joe-job.com>
X-OriginalArrivalTime: 13 Mar 2008 16:45:42.0686 (UTC) FILETIME=[AD3FEBE0:01C88529]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Pierre Ossman
>Sent: Thursday, March 13, 2008 9:35 AM
>To: Len Brown
>Cc: linux-pm@lists.linux-foundation.org; Pavel Machek; LKML; 
>Adam Belay; Andi Kleen; Lee Revell
>Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
>
>On Wed, 12 Mar 2008 15:11:17 -0400
>Len Brown <lenb@kernel.org> wrote:
>
>> > 
>> > So for now, the only viable workaround is processor.max_cstate....
>> 
>> yup, that's why we put it in.  Is it insufficient?
>> 
>
>For some value of insufficient. It is sub-optimal. I'm hoping 
>there is a way to enter C3 in a pattern that avoids the noise 
>and still gives a reduced power usage.
>

Can you try using /dev/cpu_dma_latency from an user space application.
Refer Documentation/pm_qos_interface.txt for usage. With this interface
you can change menu governor behavior from userspace, by dynamically
allowing it to use C3 or not. I am thinking that something like allowing
C3 for few seconds and blocking it for few seconds may help.

Thanks,
Venki
