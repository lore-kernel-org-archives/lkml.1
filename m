Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbZAPQar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbZAPQar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbZAPQag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:30:36 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53855 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760771AbZAPQaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:30:35 -0500
Date: Fri, 16 Jan 2009 17:30:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Message-ID: <20090116163021.GA27495@elte.hu>
References: <20090116004050.273665842@goodmis.org> <20090116112345.GC20082@elte.hu> <alpine.DEB.1.10.0901160929300.22303@gandalf.stny.rr.com> <20090116152103.GA28643@elte.hu> <alpine.DEB.1.10.0901161050470.22303@gandalf.stny.rr.com> <20090116160202.GA15209@elte.hu> <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901161111490.22303@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4709]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 16 Jan 2009, Ingo Molnar wrote:
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > > [...] We can register a function to be traced via the function pointer, 
> > > and we can pick which functions to trace, but we can not separate out 
> > > different functions for different traces.
> > 
> > Why not? We could have a hash of all traced functions with metadata 
> > attached. Since patching functions in/out would be a relatively rare 
> > operation, this would be a highly efficient read-mostly hash.
> 
> I was afraid you would say that :-)
> 
> Yes, we could add something to do this. It would take some thought on a 
> good api, and implementation. This is not an easy task by any means. We 
> need a way to map between a function call and a tracer, where a function 
> call can call more than one tracer.

Note that some other things could be consolidated under per function 
metadata: for example set_graph_function - which really is a per function 
attribute too. Plus a lot of new things would be enabled i think.

	Ingo
