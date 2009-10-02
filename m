Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZJBRFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZJBRFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 13:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZJBRFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 13:05:47 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:51452 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757102AbZJBRFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 13:05:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAF/PxUpMROOX/2dsb2JhbACBUtZuhCwEhi0
Date: Fri, 2 Oct 2009 13:05:48 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Josh Triplett <josh@joshtriplett.org>, Jon Bernard <jbernard@debian.org>,
       Jan Blunck <jblunck@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Pierre Habouzit <madcoder@debian.org>,
       Steven Munroe <munroesj@linux.vnet.ibm.com>,
       Bert Wesarg <bert.wesarg@googlemail.com>,
       Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, rp@svcs.cs.pdx.edu,
       ltt-dev@lists.casi.polymtl.ca
Subject: [RELEASE] Userspace RCU library (liburcu) 0.2.1
Message-ID: <20091002170548.GA19796@Krystal>
References: <20090929210951.GC28427@Krystal> <20091001135611.GA12323@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091001135611.GA12323@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:02:59 up 45 days,  3:52,  2 users,  load average: 1.02, 0.50,
	0.29
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Userspace RCU 0.2.1 includes:

- small header dependency fix for rculist.h.
- new "liburcu-bp.so" : "Bulletproof RCU", made especially for the UST
  userspace tracer. It's a library that sacrifices a bit of read-side
  performance for automatically monitoring thread creation/removal. See
  README for details.

Thanks,

Mathieu

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> Hi,
> 
> Here is a 0.2 version of the urcu library. It should clarify usage of
> 
> rcu_cmpxchg_pointer
> rcu_xchg_pointer
> rcu_set_pointer
> 
> which are the recommended primitives to deal with pointers.
> rcu_assign_pointer(ptr, new) is provided as compatibility layer with the
> Linux kernel semantic, but note that its semantic for the first
> parameter is IMHO odd and differs from rcu_{cmpxchg,xchg,set}_pointer.
> 
> Website URL:
> http://lttng.org/urcu
> 
> Direct link to the package:
> http://www.lttng.org/files/urcu/userspace-rcu-0.2.tar.gz
> 
> Thanks,
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
