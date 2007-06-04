Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbXFDWVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbXFDWVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 18:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbXFDWVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 18:21:00 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:44116 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbXFDWU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 18:20:59 -0400
Date: Mon, 4 Jun 2007 18:20:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070604222058.GB1169@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <20070530205927.GE6909@holomorphy.com> <20070531211258.GB904@Krystal> <20070531234154.GL6909@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070531234154.GL6909@holomorphy.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:20:22 up 7 days,  6:59,  3 users,  load average: 0.49, 0.40, 0.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III (wli@holomorphy.com) wrote:
> On Wed, May 30, 2007 at 10:00:34AM -0400, Mathieu Desnoyers wrote:
> >>> +	if (prof_on)
> >>> +		BUG_ON(cond_call_arm("profile_on"));
> 
> * William Lee Irwin III (wli@holomorphy.com) wrote:
> >> What's the point of this BUG_ON()? The condition is a priori impossible.
> 
> On Thu, May 31, 2007 at 05:12:58PM -0400, Mathieu Desnoyers wrote:
> > Not impossible: hash_add_cond_call() can return -ENOMEM if kmalloc lacks
> > memory.
> 
> Shouldn't it just propagate the errors like anything else instead of
> going BUG(), then? One can easily live without profiling if the profile
> buffers should fail to be allocated e.g. due to memory fragmentation.
> 
> These things all have to handle errors for hotplugging anyway AIUI.
> 

Cond call arming will not reserve memory anymore in the next release.
(hash table is gone).

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
