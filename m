Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbXIDUCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbXIDUCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 16:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbXIDUCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 16:02:46 -0400
Received: from tomts13.bellnexxia.net ([209.226.175.34]:52486 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753281AbXIDUCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 16:02:45 -0400
Date: Tue, 4 Sep 2007 16:02:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Christoph Lameter <clameter@sgi.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH] SLUB use cmpxchg_local
Message-ID: <20070904200242.GB8157@Krystal>
References: <20070827202203.GB5653@Krystal> <Pine.LNX.4.64.0708271324001.5884@schroedinger.engr.sgi.com> <20070827203913.GA7416@Krystal> <Pine.LNX.4.64.0708271401070.6435@schroedinger.engr.sgi.com> <20070827211003.GA10627@Krystal> <Pine.LNX.4.64.0708271421130.6566@schroedinger.engr.sgi.com> <20070827213845.GB9748@Krystal> <Pine.LNX.4.64.0708271510020.8783@schroedinger.engr.sgi.com> <20070827222715.GA16982@Krystal> <Pine.LNX.4.64.0708271811200.10344@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708271811200.10344@schroedinger.engr.sgi.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:01:14 up 36 days, 20:20,  6 users,  load average: 0.23, 0.30, 0.40
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter (clameter@sgi.com) wrote:
> Measurements on IA64 slub w/per cpu vs slub w/per cpu/cmpxchg_local 
> emulation. Results are not good:
> 

Hi Christoph,

I tried to come up with a patch set implementing the basics of a new
critical section: local_enter(flags) and local_exit(flags).

Can you try those on ia64 and tell me if the results are better ?

See the 2 next posts...

Mathieu
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
