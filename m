Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbYAWSor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbYAWSor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbYAWSoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:44:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYAWSog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:44:36 -0500
Date: Wed, 23 Jan 2008 13:25:33 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, Jan Kiszka <jan.kiszka@siemens.com>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 19/20 -v5] Trace irq disabled critical timings
Message-ID: <20080123182533.GF18698@redhat.com>
References: <20080123160236.969334052@goodmis.org> <20080123160444.197366580@goodmis.org> <20080123165353.GA12598@goodmis.org> <20080123171107.GB12598@goodmis.org> <20080123172712.GE18698@redhat.com> <1201111103.6341.73.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201111103.6341.73.camel@lappy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Wed, Jan 23, 2008 at 06:58:23PM +0100, Peter Zijlstra wrote:
> [...]
> > Is there an opportunity here to share effort with latencytop, and
> > ideally to use markers as much as possible for these event hooks?
> 
> I'm still thinking latencytop should only record stack traces and do the
> rest in user-space. 
> 
> Also, the things the latency tracer and latecytop measure are quite
> different. the latency tracer measures how long a non-schedulable
> section is, latencytop measures how a task was scheduled away.

The commonality I imagine is not in what sorts of reports they create,
or where they complete the formatting for and end-user.  It is solely
whether the kernel-side instrumentation sites can be represented by
individual markers, so that these particular tools as well as future
ones don't need to keep inserting custom code in similar or even the
same places.

- FChE
