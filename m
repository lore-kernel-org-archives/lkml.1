Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYGWIIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYGWIIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYGWIId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:08:33 -0400
Received: from il.qumranet.com ([212.179.150.194]:48721 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbYGWIIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:08:31 -0400
Message-ID: <4886E6FD.4090200@qumranet.com>
Date: Wed, 23 Jul 2008 11:08:29 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       "Feng(Eric) Liu" <eric.e.liu@intel.com>
Subject: Re: [patch 4/4] KVM-trace port to tracepoints
References: <20080717155724.897537670@polymtl.ca>	 <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com>	 <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com>	 <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins>
In-Reply-To: <1216799346.7257.125.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-07-22 at 21:46 +0300, Avi Kivity wrote:
>   
>> Jan Kiszka wrote:
>>     
>>> That's true - as long as you don't have to add/remove/modify
>>> tracepoints. I had to do this job in the past (not for KVM). Having 1
>>> spot in 1 file (based on generic probes) would be handier in that case
>>> than 5 spots in 3 files. But if the KVM tracepoints are considered
>>> stable in their number and structure, that shouldn't be an issue here.
>>>
>>>   
>>>       
>> Tracepoints aren't stable; they are artefacts of the implementation.
>>     
>
> Which IMHO makes it unsuitable for trace_mark() as that will be exported
> to user-space, and every time you change your tracepoints you'll change
> user visible things - not nice.
>   

They are used for debugging (mostly performance related), so changes are 
expected.

What uses of trace_mark() depend on a stable interface? blktrace?


-- 
error compiling committee.c: too many arguments to function

