Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbYACPSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbYACPSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYACPSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:18:10 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:40237 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753403AbYACPSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:18:09 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAAGLfEdMROHU/2dsb2JhbACBV6g/
Date: Thu, 3 Jan 2008 10:18:06 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>, akpm@linux-foundation.org,
       lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, hskinnemoen@atmel.com, mhiramat@redhat.com,
       sam@ravnborg.org, randy.dunlap@oracle.com
Subject: Re: [PATCH 2/2] Kprobes: Move kprobes examples to samples/
Message-ID: <20080103151806.GA23967@Krystal>
References: <20080103062425.GA22781@in.ibm.com> <20080103062825.GB22781@in.ibm.com> <20080103093303.GB16803@elte.hu> <20080103102233.GB28934@in.ibm.com> <20080103110459.GI29194@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080103110459.GI29194@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:14:01 up 60 days, 20:19,  5 users,  load average: 0.05, 0.05,
	0.00
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > > feature request: please make this work in the !modular case as well 
> > > - if built-in then it should just run sometime during bootup and run 
> > > the tests and report success/failure. This way automated testing can 
> > > pick up any regressions much easier.
> > 
> > Will try cook up something along those lines. It'll be easy to verify 
> > if the probes inserted and removed properly, but verifying handlers 
> > run correctly will need some work.
> > 
> > We have a sort of regression test bucket that uses expect to parse the 
> > dmesg to verify handlers did run correctly; that isn't a totally 
> > in-kernel solution anyway. I have a couple of ideas in mind to make it 
> > easier.
> 
> Great. Would be really nice to have something along the lines of 
> CONFIG_DEBUG_LOCKING_API_SELFTESTS. Those unit tests took time to 
> develop, but they caught more than 90% (!) of the internal lockdep 
> engine bugs before they ever hit mainline.
> 

I would just like to point out that the samples/ directory should keep
files as easy to read and understand for newcomers (it is meant to be
compiled Documentation examples). I see the interest in turning it into
a regression test too, but I would recommend leaving the "test" code out
of the sample module itself to improve readability.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
