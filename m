Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYCZJlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYCZJlt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbYCZJll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:41:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:63983 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbYCZJlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:41:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,557,1199692800"; 
   d="scan'208";a="309732548"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: support pebs in ds.c and disable ptraceand ds support
Date: Wed, 26 Mar 2008 09:39:46 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444019B50A0@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080321125338.GB27245@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: support pebs in ds.c and disable ptraceand ds support
Thread-Index: AciLUuejBWYZHjOzQLSSWBz/W0FKSADzzspg
References: <20080312125318.A15510@sedona.ch.intel.com> <20080321125338.GB27245@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, <roland@redhat.com>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 26 Mar 2008 09:39:02.0473 (UTC) FILETIME=[39B42B90:01C88F25]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Freitag, 21. März 2008 13:54


>> Ds.c is meant to be the resource allocator for per-thread and per-cpu
>> BTS and PEBS recording.
>> It is used by ptrace to provide execution tracing of debugged tasks.
>> It will be used by utrace for the same purpose.
>> It will be used by profilers (e.g. perfmon2).
>> It may be used by kernel debuggers to provide a kernel 
>execution trace.
>
>we could apply this if Roland Acks it - 

I moved Roland to the To: list. I hope we can resolve this in a technical discussion.


>but i guess a precondition for 
>that is to not include more ptrace extensions and to also 
>start working 
>on utrace support for it. Ptrace is something we want to reduce usage 
>of, not extend.

The patch is targeting application debuggers (in the first place). As far as I know, today's application debuggers are using ptrace. And I expect them to continue to use ptrace for some time.

I would not want to exclude existing debuggers from this feature; nor would I want to put a too big burden on debuggers if they wished to support execution tracing.

I will look into utrace as an additional interface.

Until utrace has been adopted by debuggers, I think ptrace (as its predecessor) is a good choice for an interim solution. 


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

