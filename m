Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZJGVvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZJGVvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754414AbZJGVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:51:36 -0400
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:59237 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZJGVvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:51:35 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0EAG+pzEpMROOX/2dsb2JhbACBUtVnhCoEhCWCHw
Date: Wed, 7 Oct 2009 17:50:55 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: ltt-dev@lists.casi.polymtl.ca, rp@svcs.cs.pdx.edu,
       linux-kernel@vger.kernel.org
Subject: Userspace RCU library, now with autotools
Message-ID: <20091007215055.GB14589@Krystal>
References: <20090929210951.GC28427@Krystal> <20091001135611.GA12323@Krystal> <20091002170548.GA19796@Krystal> <20091005220850.GA21419@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091005220850.GA21419@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 17:47:45 up 50 days,  8:37,  3 users,  load average: 0.36, 0.24,
	0.24
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Pierre-Marc contributed patches moving urcu to autotools. I would
appreciate if someone can test it on powerpc and s390 before I can
proceed to a release.

Available at:

git://lttng.org/userspace-rcu.git

See updated README for details.

Thanks,

Mathieu


* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> Hi again,
> 
> New update. Userspace RCU 0.2.2:
> 
> - Phases out rcu_publish_content() api.
> - Adds type checking to urcu-pointer.h pointer exchange primitives.
> 
> Mathieu
> 
> P.S.: maybe I should setup a mailing list for these announcements ?
> Comments ?
> 
> * Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> > Hello,
> > 
> > Userspace RCU 0.2.1 includes:
> > 
> > - small header dependency fix for rculist.h.
> > - new "liburcu-bp.so" : "Bulletproof RCU", made especially for the UST
> >   userspace tracer. It's a library that sacrifices a bit of read-side
> >   performance for automatically monitoring thread creation/removal. See
> >   README for details.
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > * Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > > Hi,
> > > 
> > > Here is a 0.2 version of the urcu library. It should clarify usage of
> > > 
> > > rcu_cmpxchg_pointer
> > > rcu_xchg_pointer
> > > rcu_set_pointer
> > > 
> > > which are the recommended primitives to deal with pointers.
> > > rcu_assign_pointer(ptr, new) is provided as compatibility layer with the
> > > Linux kernel semantic, but note that its semantic for the first
> > > parameter is IMHO odd and differs from rcu_{cmpxchg,xchg,set}_pointer.
> > > 
> > > Website URL:
> > > http://lttng.org/urcu
> > > 
> > > Direct link to the package:
> > > http://www.lttng.org/files/urcu/userspace-rcu-0.2.tar.gz
> > > 
> > > Thanks,
> > > 
> > > Mathieu
> > > 
> > > -- 
> > > Mathieu Desnoyers
> > > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
