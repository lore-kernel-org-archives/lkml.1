Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZDHLD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZDHLD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 07:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbZDHLDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:03:49 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59914 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbZDHLDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:03:48 -0400
Date: Wed, 8 Apr 2009 13:06:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Satoshi Oshima <satoshi.oshima.fk@hitachi.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump optimization on x86
Message-ID: <20090408110602.GA14687@one.firstfloor.org>
References: <49DA7702.5030308@redhat.com> <20090408011743.GB5977@nowhere> <49DC0307.6080107@redhat.com> <20090408101056.GA14482@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090408101056.GA14482@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 12:10:56PM +0200, Ingo Molnar wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > > But can we consider it as a small problem, assuming that kprobes 
> > > are rarely intended for a massive use in once? I guess that 
> > > usually, not a lot of functions are probed simultaneously.
> > 
> > Hm, yes and no, systemtap may use massive kprobes, because it 
> > supports "wildcard" probes. However, optimizing in default may be 
> > acceptable.
> 
> I'm curious: what is the biggest kprobe count you've ever seen, in 
> the field? 1000? 10,000? 100,000? More?

The limit is iirc how much memory the gcc compiling the probes program
consumes before running out of swap space.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
