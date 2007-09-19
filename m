Return-Path: <linux-kernel-owner+w=401wt.eu-S1762427AbXISSgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762427AbXISSgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbXISSg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:36:26 -0400
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:36225 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbXISSgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:36:25 -0400
Date: Wed, 19 Sep 2007 14:31:13 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 4/7] Immediate Values - i386 Optimization
Message-ID: <20070919183113.GC7428@Krystal>
References: <20070918210747.828804366@polymtl.ca> <20070918210853.588573678@polymtl.ca> <46F04856.3010808@goop.org> <46F04D53.6040903@zytor.com> <46F050E8.5020206@goop.org> <20070919130122.GA21750@Krystal> <46F14A58.60904@zytor.com> <46F15CB8.6010408@goop.org> <46F15ED4.40002@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46F15ED4.40002@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:27:10 up 51 days, 18:46,  3 users,  load average: 0.28, 0.69, 1.07
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Jeremy Fitzhardinge wrote:
> > 
> > Cross-cache-line, sure.  But what about just not sizeof aligned?  If its
> > enough to avoid cross-cache-line, then that's simpler.
> > 
> 
> Not really.  It pretty much comes down to the same problem.
> 
> > Which is something I was going to comment on: Mathieu, you try to align
> > the constant itself, but you don't prevent the instruction overall from
> > crossing a cache line.  Given how delicate all this stuff is, it seems
> > like a good idea to do that.
> 
> Given how delicate all his stuff is, it would be interesting to know the
> magnitude of the expected payoff, which I personally don't remember seeing.
> 

Please have a look at the patch header at:
http://lkml.org/lkml/2007/9/18/346

And at the documentation:
http://lkml.org/lkml/2007/9/18/375

Where I provide speedups experienced with this patch. Please note that
my primary goal is to provide non intrusive instrumentation with the
Linux Kernel Markers, and the immediate values are the underlying
mechanism that help enabling/disabling dynamically instrumentation sites
with the smallest effect possible (and still get the local variables
in the middle of a function compiled with -O2...).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
