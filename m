Return-Path: <linux-kernel-owner+w=401wt.eu-S1759272AbZCRSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759272AbZCRSJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbZCRSJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:09:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:55494 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZCRSJN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,385,1233561600"; 
   d="scan'208";a="121650072"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       "eranian@googlemail.com" <eranian@googlemail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 18 Mar 2009 18:08:38 +0000
Subject: RE: [patch 1/5] x86, bts: detect size of DS fields
Thread-Topic: [patch 1/5] x86, bts: detect size of DS fields
Thread-Index: Acmm/NOiijrhTk/gSoehVHQcmoTHDAAAEWlwADzn9RA=
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E87B75264@irsmsx504.ger.corp.intel.com>
References: <20090313104218.A30096@sedona.ch.intel.com>
 <20090313110357.GC31094@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A663C47@irsmsx504.ger.corp.intel.com>
 <20090317105558.GK6477@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A664285@irsmsx504.ger.corp.intel.com>
 <20090317123442.GB22759@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A6642C7@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E4A6642C7@irsmsx504.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: VtTf Wk0L aDab mXT7 m12P yy2L /e3f AAn/Jg== ABJaKg==
 ABu6lw== ACvAWQ== AGUf4g== AGaEwg== AI/xPg== ALJgAQ==
 ALUQrQ==;9;YQBrAEAAbABpAG4AdQB4AC4AagBmAC4AaQBuAHQAZQBsAC4AYwBvAG0AOwBlAHIAYQBuAGkAYQBuAEAAZwBvAG8AZwBsAGUAbQBhAGkAbAAuAGMAbwBtADsAaABwAGEAQAB6AHkAdABvAHIALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBtAGEAcgBrAHUAcwAuAHQALgBtAGUAdAB6AGcAZQByAEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBtAGkAbgBnAG8AQABlAGwAdABlAC4AaAB1ADsAbwBsAGUAZwBAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwByAG8AbABhAG4AZABAAHIAZQBkAGgAYQB0AC4AYwBvAG0AOwB0AGcAbAB4AEAAbABpAG4AdQB0AHIAbwBuAGkAeAAuAGQAZQA=;Sosha1_v1;7;{A23F72C8-1848-4740-A34F-C7B6D0EC9B14};bQBhAHIAawB1AHMALgB0AC4AbQBlAHQAegBnAGUAcgBAAGkAbgB0AGUAbAAuAGMAbwBtAA==;Wed,
 18 Mar 2009 18:08:38
 GMT;UgBFADoAIABbAHAAYQB0AGMAaAAgADEALwA1AF0AIAB4ADgANgAsACAAYgB0AHMAOgAgAGQAZQB0AGUAYwB0ACAAcwBpAHoAZQAgAG8AZgAgAEQAUwAgAGYAaQBlAGwAZABzAA==
x-cr-puzzleid: {A23F72C8-1848-4740-A34F-C7B6D0EC9B14}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Metzger, Markus T
>Sent: Tuesday, March 17, 2009 1:58 PM
>To: Ingo Molnar

Ingo, Stephane,


>>That's not really a good solution - GFP_ATOMIC is not a reliable
>>form of allocation.
>
>In that case, I would need to double the interface. So far, I used
>task == NULL to indicate tracing on the current cpu. I could turn
>this into:
>  ds_request_bts_task(struct task_struct *task, ....) and
>  ds_request_bts_cpu(int cpu, ....)
>
>This way, I could do the allocation using GFP_KERNEL and then
>do the wrmsrl() to enable tracing using smp_call_function().

I added the above _task and _cpu variants to ds_request.

Ds_whatever() calls require interrupts disabled for the existing
functions. I added _noirq variants for most functions that may be
called with interrupts disabled as long as they are called on the
cpu they affect.

I added a few WARN_ON(irqs_disabled()), and I have not seen one, yet.

Ds_request_~() must be called with interrupts enabled, since it
needs to allocate memory.

Stephane, is that OK for perfmon?

I will add a few more selftests to cover the _noirq path, as well.

I should be able to send the patches in a few days.


Meanwhile, I will send the patch to turn GFP_KERNEL into GFP_ATOMIC.
The other patch will undo those changes.



>>the other callsites are buggy too:
>>
>>                smp_call_function_single(cpu, bts_trace_start_cpu, NULL, 1);
>>
>>done under the bts_tracer_lock in addition to an atomic IPI
>>context.
>
>That lock synchronizes the on_each_cpu initialization calls with the
>hotplug handler.
>The for_each_online_cpu iteration in smp_call_function_many() may
>race with the smp_call_function_single() when a new cpu arrives or
>departs.

I'm not sure I understood you correctly.
I interpreted your comment that the lock is unnecessary since we run with
interrupts disabled, anyway.

Please let me know if I understood you wrong.


>>for_each_online_cpu() done under the mutex would be better i
>>guess, plus you can allocate any memory before you do the SMP
>>cross-call, and pass it to the IPI handler via the data
>>parameter. (NULL in the sequence above)
>
>The memory is allocated by ds_request_bts(). It holds the tracer
>struct returned to the caller. The struct is private to ds.c.

That's almost how it now is.

Ds_whatever() calls can now be made from any cpu; ds.c will take care
of running on the correct cpu when writing msr's (I use wrmsr_on_cpu()).

Ds_request() still allocates memory, though.

The hw-branch-tracer will now use for_each_online_cpu() loops for
almost everything.

The ftrace framework unfortunately adds the cpu id automatically, so
I still need to do on_each_cpu() to collect the trace.


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

