Return-Path: <linux-kernel-owner+w=401wt.eu-S1756913AbXJ2Trt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913AbXJ2Trt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755450AbXJ2TpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:45:16 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56382 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754755AbXJ2TpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:45:12 -0400
Date: Mon, 29 Oct 2007 12:45:10 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029124510.002559e0.pj@sgi.com>
In-Reply-To: <1193676854.5035.121.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<1193412644.5032.13.camel@localhost>
	<alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
	<20071026120037.7b95a136.pj@sgi.com>
	<alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
	<1193433239.5032.95.camel@localhost>
	<alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
	<1193434278.5032.106.camel@localhost>
	<alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
	<20071026194144.6042316a.pj@sgi.com>
	<alpine.DEB.0.9999.0710262149090.26464@chino.kir.corp.google.com>
	<20071027161955.e9d4d2db.pj@sgi.com>
	<1193676854.5035.121.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Again, we stumble upon the notion of "intent".  If the intent is just to
> spread allocations to share bandwidth, it probably doesn't matter.  If,
> on the other hand, the original mask was carefully constructed, taking
> into consideration the distances between the memories specified and
> other resources [cpus in the cpuset, other memories in the cpuset, IO
> adpater connection points, ...], there is a lot more to consider than
> just preserving the cpuset relative positions of the nodes.

Yes - as I noted in an earlier reply, the kernel just provides the
mechanisms.  It's up to user level code and people to decide whether
moving jobs around is a worthwhile activity in their situation.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
