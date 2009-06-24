Return-Path: <linux-kernel-owner+w=401wt.eu-S1756162AbZFXQtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162AbZFXQtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 12:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZFXQtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 12:49:12 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:45452 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbZFXQtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 12:49:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtEEAGfxQUpMQWRX/2dsb2JhbACBUdMjhAsFgTQ
Date: Wed, 24 Jun 2009 12:49:09 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Tom Zanussi <tzanussi@gmail.com>, karim@opersys.com,
       Michel Dagenais <michel.dagenais@polymtl.ca>,
       ltt-dev@lists.casi.polymtl.ca, Lai Jiangshan <laijs@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: Dual-licensing LTTng, marker and tracepoints under
	GPLv2+/LGPLv2.1+
Message-ID: <20090624164909.GA20653@Krystal>
References: <4A412702.80707@polymtl.ca> <20090623191128.GA19010@Krystal> <20090623191513.GA20253@Krystal> <20090624004356.GB28911@Krystal> <20090624083334.GB16850@elte.hu> <20090624141438.GA15420@Krystal> <y0mprctzj5v.fsf@fche.csb>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <y0mprctzj5v.fsf@fche.csb>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:44:37 up 116 days, 13:10,  3 users,  load average: 0.00, 0.03,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Frank Ch. Eigler (fche@redhat.com) wrote:
> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> 
> > [...]  The goal we pursue by dual-licensing with GPLv2/LGPLv2.1 is
> > to permit instrumented applications to be themselves distributed
> > under other license than GPL. [...]
> 
> Is there some reason you can't just fork/copy off some earlier version
> of these files over which you had sole authorship (if any)?
> 

Actually, for LTTng, I own the copyright of almost everything we need.
Most files written by others are mainly the debugfs interfaces done by
Fujitsu. There is some derived work from RelayFS in
ltt/ltt-relay-alloc.c and include/linux/ltt-relay.h, where getting IBM's
approval would be good, but I think in the end this will end up being
only a few tens of lines.

> 
> > [...]The goal is to permit this library, which includes the
> > tracepoints, markers and LTTng features, to be used by userspace
> > applications and libraries so they can add static instrumentation
> > (as we currently do in the kernel). [...]
> 
> Just in case you're not aware, some API prior art for this is the
> dtrace sdt.h widget (already supported by systemtap), and of course
> it has no similarity to the various kernel tracing APIs.

Yep, we're aware of this. However, last time I checked, dtrace SDT used
a breakpoint even for their userspace tracing, which has a way too large
performance overhead for our needs.

Moreover, they support only very, very limited typing (0 to 5 u32). In
this respect, tracepoints and markers are much more flexible.

Thanks,

Mathieu

> 
> - FChE
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
