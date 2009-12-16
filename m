Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbZLPBkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbZLPBkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZLPBkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:40:40 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:35143 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750838AbZLPBkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:40:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuwEAIrIJ0uuWOw8/2dsb2JhbACBS9VahCsE
Date: Tue, 15 Dec 2009 20:40:31 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
	cleanup
Message-ID: <20091216014031.GA12282@Krystal>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B2830CC.7040309@kernel.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 20:38:09 up 13 days, 16:28,  4 users,  load average: 0.13, 0.10,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tejun Heo (tj@kernel.org) wrote:
> Hello, Mathieu.
> 
> On 12/16/2009 02:43 AM, Mathieu Desnoyers wrote:
> > So I think accessing the "local_t offset" through percpu pointers should
> > be fine if I allocate struct ltt_chanbuf through the per cpu API.
> > However, I wonder how to deal with the commit_count counters, because
> > there is an indirection level.
> 
> Are they different in numbers for different cpus?

Nope, there is the same number of sub-buffers for each per-cpu buffer.
I just want to see if supplementary indirections are allowed after
dereferencing the per-cpu pointer ?

Thanks,

Mathieu

> 
> Thanks.
> 
> -- 
> tejun

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
