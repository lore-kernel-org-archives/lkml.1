Return-Path: <linux-kernel-owner+w=401wt.eu-S1755657AbYCZJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657AbYCZJQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYCZJQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 05:16:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:6098 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbYCZJQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 05:16:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,557,1199692800"; 
   d="scan'208";a="540178329"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [patch] x86, ptrace: support pebs in ds.c and disable ptraceand ds support
Date: Wed, 26 Mar 2008 09:16:53 -0000
Message-ID: <029E5BE7F699594398CA44E3DDF55444019B5025@swsmsx413.ger.corp.intel.com>
In-Reply-To: <20080321125338.GB27245@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] x86, ptrace: support pebs in ds.c and disable ptraceand ds support
Thread-Index: AciLUuejBWYZHjOzQLSSWBz/W0FKSADzsJww
References: <20080312125318.A15510@sedona.ch.intel.com> <20080321125338.GB27245@elte.hu>
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <ak@suse.de>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <tglx@linutronix.de>, <markus.t.metzger@gmail.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, <roland@redhat.com>,
       <akpm@linux-foundation.org>, <mtk.manpages@gmail.com>,
       <eranian@googlemail.com>, "Villacis, Juan" <juan.villacis@intel.com>
X-OriginalArrivalTime: 26 Mar 2008 09:16:09.0666 (UTC) FILETIME=[07727220:01C88F22]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Freitag, 21. März 2008 13:54

>> Polish the ds.h interface and add support for PEBS.
>> 
>> Guard DS support and the ptrace interface to BTS by CONFIG macros;
>> disabled per default.
>> 
>> Ds.c is meant to be the resource allocator for per-thread and per-cpu
>> BTS and PEBS recording.
>> It is used by ptrace to provide execution tracing of debugged tasks.
>> It will be used by utrace for the same purpose.
>> It will be used by profilers (e.g. perfmon2).
>> It may be used by kernel debuggers to provide a kernel 
>execution trace.
>
>we could apply this if Roland Acks it - but i guess a precondition for 
>that is to not include more ptrace extensions and to also 
>start working 
>on utrace support for it. Ptrace is something we want to reduce usage 
>of, not extend.

The patch is not adding new features. It is merely re-establishing the state before the patch mysteriously disappeared from x86#testing.

You actually asked me to resubmit the patch.


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

