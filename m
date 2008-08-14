Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYHNRi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYHNRi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYHNRiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:38:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58027 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYHNRiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:38:19 -0400
Message-ID: <48A46BD4.2050908@zytor.com>
Date: Thu, 14 Aug 2008 10:31:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Steven Rostedt <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [RFC PATCH] x86 alternatives : fix LOCK_PREFIX race with	preemptible
 kernel and CPU hotplug
References: <alpine.LFD.1.10.0808131119290.3462@nehalem.linux-foundation.org> <20080813184142.GM1366@one.firstfloor.org> <20080813193011.GC15547@Krystal> <20080813193715.GQ1366@one.firstfloor.org> <20080813200119.GA18966@Krystal> <20080813234156.GA25775@Krystal> <48A375E3.9090609@zytor.com> <48A388CE.2020404@goop.org> <20080814014944.GA31883@Krystal> <48A3A806.8060509@goop.org> <20080814151805.GA29507@Krystal> <48A465BA.5050406@goop.org> <48A468F5.4050308@zytor.com> <48A46B41.5000409@goop.org>
In-Reply-To: <48A46B41.5000409@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
>>
>> He doesn't specify what kind of Xeon it is (there are three completely 
>> different CPUs under the Xeon brand name: P3 Xeon, P4 Xeon, and Core 2 
>> Xeon), but I think it's a P4 Xeon.
>>
>> Netburst sucked in so many ways, and this is one of them.
> 
> I presume it's this one:
>> Xeon cpuinfo :
>>
>> processor    : 0
>> vendor_id    : GenuineIntel
>> cpu family    : 6
>> model        : 23
>> model name    : Intel(R) Xeon(R) CPU           E5405  @ 2.00GHz

> 
> I've given up trying to remember what "E5405" might mean, but that 
> feature list suggests a relatively modern microarchitecture.
> 

E5405 is the 45 nm Core 2 Quad Xeon.

	-hpa
