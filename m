Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbYGWKIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbYGWKIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 06:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYGWKIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 06:08:43 -0400
Received: from il.qumranet.com ([212.179.150.194]:30229 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566AbYGWKIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 06:08:42 -0400
Message-ID: <48870329.2080401@qumranet.com>
Date: Wed, 23 Jul 2008 13:08:41 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Peter Zijlstra <peterz@infradead.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
References: <20080717155724.897537670@polymtl.ca> <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com> <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com> <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins> <4886E6FD.4090200@qumranet.com> <1216803303.7257.138.camel@twins> <20080723100314.GA2847@infradead.org>
In-Reply-To: <20080723100314.GA2847@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Jul 23, 2008 at 10:55:03AM +0200, Peter Zijlstra wrote:
>   
>> Andrew raised the whole point about trace_mark() generating an
>> user-visible interface and thus it should be stable, and I agree with
>> that.
>>     
>
> I'm not sure why this comes up again and again, but it's utter bullshit.
> trace_mark does not generate any kind of user interface, just purely
> a kernel internal interface.
>   

trace_mark() is implement kvmtrace, which is propagated to userspace.  
So while trace_mark() itself is not a userspace interface, one of its 
users is.

It's an unstable interface.  But so is dmesg; that's the nature of tracing.

-- 
error compiling committee.c: too many arguments to function

