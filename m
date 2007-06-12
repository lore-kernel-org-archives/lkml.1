Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXFLMyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXFLMyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 08:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755627AbXFLMyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 08:54:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:51471 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbXFLMyI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 08:54:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,411,1175497200"; 
   d="scan'208";a="255929370"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [stable] [PATCH] ACPI: Move timer broadcast and pmtimer accessbefore C3 arbiter shutdown
Date: Tue, 12 Jun 2007 05:54:04 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F50101D9F3@scsmsx415.amr.corp.intel.com>
In-Reply-To: <1181636767.8176.199.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [stable] [PATCH] ACPI: Move timer broadcast and pmtimer accessbefore C3 arbiter shutdown
Thread-Index: Acesy1XBzlyadCMqTJG+/1zK2V+MjQAJSWUw
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Thomas Gleixner" <tglx@linutronix.de>,
       "Chris Wright" <chrisw@sous-sol.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>, "Andi Kleen" <ak@suse.de>,
       "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>,
       "Dave Jones" <davej@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Stable Team" <stable@kernel.org>, "Len Brown" <lenb@kernel.org>
X-OriginalArrivalTime: 12 Jun 2007 12:54:05.0656 (UTC) FILETIME=[C2602D80:01C7ACF0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de] 
>Sent: Tuesday, June 12, 2007 1:26 AM
>To: Chris Wright
>Cc: Andrew Morton; LKML; Andi Kleen; Udo A. Steinberg; 
>Pallipadi, Venkatesh; Dave Jones; Ingo Molnar; Arjan van de 
>Ven; Stable Team; Len Brown
>Subject: Re: [stable] [PATCH] ACPI: Move timer broadcast and 
>pmtimer accessbefore C3 arbiter shutdown
>
>On Mon, 2007-06-11 at 18:07 -0700, Chris Wright wrote:
>> * Andrew Morton (akpm@linux-foundation.org) wrote:
>> > hm, this needs a bit of help to get it to work against 
>Len's current tree.
>> 
>> Here's some help, compile tested only.  Udo/Thomas, was this found to
>> be root cause of a real bug?  I didn't want this to get lost if it's
>> still meant to be relevant for -stable.
>
>Chris,
>
>I fixed this against -mm already. I don't think that it is relevant for
>stable. The issue was found with Venkis hpet force enable patches on a
>ICH4 system. I doubt that any of those systems has hpet enabled in the
>BIOS. It should not affect later ICH chip sets. Venki, is this 
>correct ?
>

Yes. This issue is only when HPET timer is used on ICH4. And by default 
HPET is not enabled on those chipsets. So, we don't need this patch
for stable.

Thanks,
Venki
