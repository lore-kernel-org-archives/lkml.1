Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYGWJcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYGWJcU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYGWJcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:32:10 -0400
Received: from il.qumranet.com ([212.179.150.194]:20623 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbYGWJcJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:32:09 -0400
Message-ID: <4886FA97.40104@qumranet.com>
Date: Wed, 23 Jul 2008 12:32:07 +0300
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
References: <20080717155724.897537670@polymtl.ca>	 <20080717160003.359557938@polymtl.ca> <487F7800.4010502@siemens.com>	 <20080717172853.GB29855@Krystal> <488604F8.1040008@siemens.com>	 <48862B01.7070907@qumranet.com> <1216799346.7257.125.camel@twins>	 <4886E6FD.4090200@qumranet.com> <1216803303.7257.138.camel@twins>
In-Reply-To: <1216803303.7257.138.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> There are currently no trace_mark() sites in the kernel that I'm aware
> of (except for the scheduler :-/, and those should be converted to
> tracepoints ASAP).
>
> Andrew raised the whole point about trace_mark() generating an
> user-visible interface and thus it should be stable, and I agree with
> that.
>
> What that means is that trace_mark() can only be used for really stable
> points.
>
> This in turn means we might as well use trace points.
>
> Which allows for the conclusion that trace_mark() is not needed and
> could be removed from the kernel.
>
> However - it might be handy for ad-hoc debugging purposes that never see
> the light of day (linus' git tree in this case). So on those grounds one
> could argue against removing trace_mark

But trace_mark() is so wonderful.  Can't we just declare the tracemarks 
as a non-stable interface?

Perhaps add an unstable_trace_mark() to make it clear.

-- 
error compiling committee.c: too many arguments to function

