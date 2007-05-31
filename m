Return-Path: <linux-kernel-owner+w=401wt.eu-S1759365AbXEaVNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759365AbXEaVNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbXEaVNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:13:01 -0400
Received: from tomts25.bellnexxia.net ([209.226.175.188]:54068 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751148AbXEaVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:13:00 -0400
Date: Thu, 31 May 2007 17:12:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 9/9] Scheduler profiling - Use conditional calls
Message-ID: <20070531211258.GB904@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140229.811672406@polymtl.ca> <20070530205927.GE6909@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070530205927.GE6909@holomorphy.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:09:21 up 3 days,  5:47,  4 users,  load average: 0.72, 0.42, 0.32
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* William Lee Irwin III (wli@holomorphy.com) wrote:
> On Wed, May 30, 2007 at 10:00:34AM -0400, Mathieu Desnoyers wrote:
> > Use conditional calls with lower d-cache hit in optimized version as a
> > condition for scheduler profiling call.
> [...]
> > +	if (prof_on)
> > +		BUG_ON(cond_call_arm("profile_on"));
> 
> What's the point of this BUG_ON()? The condition is a priori impossible.
> 

Not impossible: hash_add_cond_call() can return -ENOMEM if kmalloc lacks
memory.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
