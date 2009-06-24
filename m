Return-Path: <linux-kernel-owner+w=401wt.eu-S1761121AbZFXRXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761121AbZFXRXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 13:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZFXRX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 13:23:27 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33653 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295AbZFXRX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 13:23:26 -0400
Date: Wed, 24 Jun 2009 10:23:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>, karim@opersys.com,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Lai Jiangshan <laijs@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: Dual-licensing LTTng, marker and tracepoints under
	GPLv2+/LGPLv2.1+
Message-ID: <20090624172326.GJ6779@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal> <20090623191513.GA20253@Krystal> <20090624004356.GB28911@Krystal> <20090624083334.GB16850@elte.hu> <20090624141438.GA15420@Krystal> <y0mprctzj5v.fsf@fche.csb> <20090624164909.GA20653@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624164909.GA20653@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 12:49:09PM -0400, Mathieu Desnoyers wrote:
> * Frank Ch. Eigler (fche@redhat.com) wrote:
> > Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> > 
> > > [...]  The goal we pursue by dual-licensing with GPLv2/LGPLv2.1 is
> > > to permit instrumented applications to be themselves distributed
> > > under other license than GPL. [...]
> > 
> > Is there some reason you can't just fork/copy off some earlier version
> > of these files over which you had sole authorship (if any)?
> > 
> 
> Actually, for LTTng, I own the copyright of almost everything we need.
> Most files written by others are mainly the debugfs interfaces done by
> Fujitsu. There is some derived work from RelayFS in
> ltt/ltt-relay-alloc.c and include/linux/ltt-relay.h, where getting IBM's
> approval would be good, but I think in the end this will end up being
> only a few tens of lines.

It is going to be a -lot- easier and faster to simply rewrite a few tens
of lines than to get any kind of approval.  ;-)

I cannot reasonably argue that the prior approval for RCU covers tracing,
sad to say.  So unless there is something very special about the few
tens of lines, could you please look at just clean-room rewriting them?

							Thanx, Paul

> > > [...]The goal is to permit this library, which includes the
> > > tracepoints, markers and LTTng features, to be used by userspace
> > > applications and libraries so they can add static instrumentation
> > > (as we currently do in the kernel). [...]
> > 
> > Just in case you're not aware, some API prior art for this is the
> > dtrace sdt.h widget (already supported by systemtap), and of course
> > it has no similarity to the various kernel tracing APIs.
> 
> Yep, we're aware of this. However, last time I checked, dtrace SDT used
> a breakpoint even for their userspace tracing, which has a way too large
> performance overhead for our needs.
> 
> Moreover, they support only very, very limited typing (0 to 5 u32). In
> this respect, tracepoints and markers are much more flexible.
> 
> Thanks,
> 
> Mathieu
> 
> > 
> > - FChE
> > 
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
