Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYLECdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYLECdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 21:33:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbYLECdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 21:33:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54283 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbYLECdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 21:33:00 -0500
To: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 2/3] performance counters: documentation
From: Andi Kleen <andi@firstfloor.org>
References: <20081204225345.654705757@linutronix.de>
	<20081204230228.557959174@linutronix.de>
	<18744.30427.440468.829807@cargo.ozlabs.ibm.com>
Date: Fri, 05 Dec 2008 03:33:13 +0100
In-Reply-To: <18744.30427.440468.829807@cargo.ozlabs.ibm.com> (Paul Mackerras's message of "Fri, 5 Dec 2008 11:33:31 +1100")
Message-ID: <87myfbwdue.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras <paulus@samba.org> writes:
>> +
>> +[ Note: more hw_event_types are supported as well, but they are CPU
>> +  specific and are enumerated via /sys on a per CPU basis. Raw hw event
>> +  types can be passed in as negative numbers. For example, to count
>> +  "External bus cycles while bus lock signal asserted" events on Intel
>> +  Core CPUs, pass in a -0x4064 event type value. ]
>
> This is going to be a huge problem, at least on powerpc, because it
> means that the kernel will have to know which events can be counted on
> which counters and what values need to be put in the control registers
> to select them.

P4 has similar problems, and to some extent there's also the same
problem on newer Intel CPUs (e.g. with fixed counters and if you
consider PEBS which has some special restrictions)

-Andi

-- 
ak@linux.intel.com
