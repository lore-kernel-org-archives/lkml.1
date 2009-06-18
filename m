Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbZFRKYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbZFRKYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 06:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756997AbZFRKYd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 06:24:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:35830 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536AbZFRKYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 06:24:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,243,1243839600"; 
   d="scan'208";a="467494955"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Thu, 18 Jun 2009 11:23:59 +0100
Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
	trace support"
Thread-Topic: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch
	trace support"
Thread-Index: Acnq3W9qc0zQykQwSmmmONQ+SHjnNgAbXFZgASz3vFA=
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBBD00DC5@irsmsx504.ger.corp.intel.com>
References: <tip-511b01bdf64ad8a38414096eab283c7784aebfc4@git.kernel.org>
 <928CFBE8E7CB0040959E56B4EA41A77EBBC6544B@irsmsx504.ger.corp.intel.com>
 <1244702183.6691.8.camel@laptop> <20090611102159.GA31719@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EBBC6555D@irsmsx504.ger.corp.intel.com>
 <20090611214124.GA4133@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EBBC65961@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EBBC65961@irsmsx504.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Metzger, Markus T
>Sent: Friday, June 12, 2009 1:05 PM
>To: Ingo Molnar
>Cc: Peter Zijlstra; linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com; oleg@redhat.com;
>tglx@linutronix.de; linux-tip-commits@vger.kernel.org
>Subject: RE: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>
>>-----Original Message-----
>>From: Ingo Molnar [mailto:mingo@elte.hu]
>>Sent: Thursday, June 11, 2009 11:41 PM
>>To: Metzger, Markus T
>>Cc: Peter Zijlstra; linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com; oleg@redhat.com;
>>tglx@linutronix.de; linux-tip-commits@vger.kernel.org
>>Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>>
>>
>>* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>>
>>> >-----Original Message-----
>>> >From: Ingo Molnar [mailto:mingo@elte.hu]
>>> >Sent: Thursday, June 11, 2009 12:22 PM
>>> >To: Peter Zijlstra
>>> >Cc: Metzger, Markus T; linux-kernel@vger.kernel.org; mingo@redhat.com; hpa@zytor.com;
>>oleg@redhat.com;
>>> >tglx@linutronix.de; linux-tip-commits@vger.kernel.org
>>> >Subject: Re: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>>> >
>>> >
>>> >* Peter Zijlstra <peterz@infradead.org> wrote:
>>> >
>>> >> On Thu, 2009-06-11 at 07:30 +0100, Metzger, Markus T wrote:
>>> >> > >-----Original Message-----
>>> >> > >From: tip-bot for Ingo Molnar [mailto:mingo@elte.hu]
>>> >> > >Sent: Thursday, June 11, 2009 1:37 AM
>>> >> > >To: linux-tip-commits@vger.kernel.org
>>> >> > >Cc: hpa@zytor.com; mingo@redhat.com; peterz@infradead.org; Metzger, Markus T;
>oleg@redhat.com;
>>> >> > >tglx@linutronix.de; mingo@elte.hu
>>> >> > >Subject: [tip:tracing/core] Revert "x86, bts: reenable ptrace branch trace support"
>>> >> > >
>>> >> > >Commit-ID:  511b01bdf64ad8a38414096eab283c7784aebfc4
>>> >> > >Gitweb:     http://git.kernel.org/tip/511b01bdf64ad8a38414096eab283c7784aebfc4
>>> >> > >Author:     Ingo Molnar <mingo@elte.hu>
>>> >> > >AuthorDate: Thu, 11 Jun 2009 00:32:00 +0200
>>> >> > >Committer:  Ingo Molnar <mingo@elte.hu>
>>> >> > >CommitDate: Thu, 11 Jun 2009 00:32:00 +0200
>>> >> > >
>>> >> > >Revert "x86, bts: reenable ptrace branch trace support"
>>> >> > >
>>> >> > >This reverts commit 7e0bfad24d85de7cf2202a7b0ce51de11a077b21.
>>> >> > >
>>> >> > >A late objection to the ABI has arrived:
>>> >> > >
>>> >> > >   http://lkml.org/lkml/2009/6/10/253
>>> >> >
>>> >> > I thought that this has been resolved. See for example http://lkml.org/lkml/2009/6/10/257.
>>> >> >
>>> >> > Peters concerns were that Debug Store details are exposed to user space, which is
>>> >> > not the case. Debug Store itself is fully in-kernel and the expectation of a
>>> >> > user-defined buffer can be implemented on top of the Debug Store changes that
>>> >> > Peter expects are needed to support PEBS.
>>> >> >
>>> >> > A user-defined trace buffer size is required to support
>>> >> > different usage models. Some users only need a small amount of
>>> >> > trace, whereas others need a big amount. The interface will have
>>> >> > to reflect that in some way.
>>> >>
>>> >> Right, your last email did explain how we could keep per task
>>> >> in-kernel buffers and fill them from the DS and still have them of
>>> >> user-specified size.
>>> >>
>>> >> That would indeed keep the proposed ABI workable, what I'm still
>>> >> not liking is that this buffer is in-kernel, but I guess that
>>> >> might be something for other people to have an opinion on.
>>> >
>>> > Hm. Wrt. the ABI, wouldnt it make more sense to expose this PMU
>>> > feature via perfcounters: a sampling hw-branch-executions
>>> > counter, with interval=1.
>>> >
>>> > That would give the exact existing semantics, plus a lot lot
>>> > more. Markus?
>>>
>>> What more would we get?
>>
>>There's numerous direct functionality advantages:
>>
>> - We will get all the sampling features of perfcounters such as
>>   timed samples, CPU ID samples. Some will be approximate (timing),
>>   some precise (CPU ID).
>>
>> - We will get the advanced workflow isolation features: we could
>>   sample on a per CPU basis (system-wide BTS), and we could sample
>>   child tasks automatically. The current code is limited to a
>>   single task.
>>
>> - We will sample other types of information into the same outgoing
>>   event buffer: for example branch-miss events, intermixed with BTS
>>   records. This could help not just the narrow purpose of
>>   debugging, but also the purpose of performance analysis.
>>
>> - There's a rich and fast/efficient VFS based APIs to wait for
>>   event overflows: poll(), read(), mmap().
>>
>> - Remote sampling via perfcounters is transparent, while ptrace
>>   sampling can be seen by apps.
>>
>>There's maintenance advantages as well from the x86 architecture and
>>scheduler maintenance point of view:
>>
>> - We would have a single facility handling the Debug Store, and
>>   we'd have almost all pieces in place for PEBS support in
>>   perfcounters as well so there's good synergy.
>
>I'm not exactly sure what you are proposing.
>
>There currently is a single facility handling Debug Store which is used
>by perfmon for PEBS sampling and by BTS for branch tracing. The ptrace
>interface is a thin layer that allows debuggers to easily access the
>part that is relevant for them.
>
>
>Are you proposing a single abstraction of sampling and branch tracing events
>using records of different sizes in one big stream?

Ingo,

I did not hear from you.
Could you be a bit more specific about what you have in mind regarding this?

regards,
markus.
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

