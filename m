Return-Path: <linux-kernel-owner+w=401wt.eu-S933184AbZDHPC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbZDHPC3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbZDHPBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:01:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47099 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765813AbZDHPBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:01:23 -0400
Message-ID: <49DCBC12.3040700@redhat.com>
Date: Wed, 08 Apr 2009 08:00:34 -0700
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: "Frank Ch. Eigler" <fche@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Avi Kivity <avi@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump optimization
 on x86
References: <49DA7702.5030308@redhat.com> <20090408011743.GB5977@nowhere> <49DC0307.6080107@redhat.com> <20090408101056.GA14482@elte.hu> <20090408110602.GA14687@one.firstfloor.org> <20090408130150.GC13827@redhat.com>
In-Reply-To: <20090408130150.GC13827@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frank Ch. Eigler wrote:
> On Wed, Apr 08, 2009 at 01:06:02PM +0200, Andi Kleen wrote:
>> [...]
>>> I'm curious: what is the biggest kprobe count you've ever seen, in 
>>> the field? 1000? 10,000? 100,000? More?
>> The limit is iirc how much memory the gcc compiling the probes program
>> consumes before running out of swap space.
> 
> On a machine with lots of free RAM, gcc will not hold itself back.  On
> my home server, a 40000-kprobe script compiled (pass 4) in about 4
> seconds using about 200MB RAM.

Hm, when 40,000 kprobes are optimized, it will consume less than 8MB ...
I guess that is acceptable for recent machines.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

