Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbZDHKLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbZDHKLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 06:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627AbZDHKLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 06:11:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47006 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756112AbZDHKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 06:11:41 -0400
Date: Wed, 8 Apr 2009 12:10:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
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
Subject: Re: [RFC][PROTO][PATCH -tip 0/7] kprobes: support jump optimization
	on x86
Message-ID: <20090408101056.GA14482@elte.hu>
References: <49DA7702.5030308@redhat.com> <20090408011743.GB5977@nowhere> <49DC0307.6080107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49DC0307.6080107@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Masami Hiramatsu <mhiramat@redhat.com> wrote:

> > But can we consider it as a small problem, assuming that kprobes 
> > are rarely intended for a massive use in once? I guess that 
> > usually, not a lot of functions are probed simultaneously.
> 
> Hm, yes and no, systemtap may use massive kprobes, because it 
> supports "wildcard" probes. However, optimizing in default may be 
> acceptable.

I'm curious: what is the biggest kprobe count you've ever seen, in 
the field? 1000? 10,000? 100,000? More?

	Ingo
