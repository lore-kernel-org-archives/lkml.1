Return-Path: <linux-kernel-owner+w=401wt.eu-S1765515AbZDHNJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765515AbZDHNJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765362AbZDHNDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:03:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55021 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765352AbZDHNDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:03:42 -0400
Date: Wed, 8 Apr 2009 09:01:50 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
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
Subject: Re: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump optimization on x86
Message-ID: <20090408130150.GC13827@redhat.com>
References: <49DA7702.5030308@redhat.com> <20090408011743.GB5977@nowhere> <49DC0307.6080107@redhat.com> <20090408101056.GA14482@elte.hu> <20090408110602.GA14687@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408110602.GA14687@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 01:06:02PM +0200, Andi Kleen wrote:
> [...]
> > I'm curious: what is the biggest kprobe count you've ever seen, in 
> > the field? 1000? 10,000? 100,000? More?
> 
> The limit is iirc how much memory the gcc compiling the probes program
> consumes before running out of swap space.

On a machine with lots of free RAM, gcc will not hold itself back.  On
my home server, a 40000-kprobe script compiled (pass 4) in about 4
seconds using about 200MB RAM.

- FChE
