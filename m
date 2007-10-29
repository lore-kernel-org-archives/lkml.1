Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbXJ2SlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbXJ2SlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbXJ2SlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:41:13 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:52163 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752496AbXJ2SlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:41:12 -0400
Date: Mon, 29 Oct 2007 11:41:09 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071029114109.46285026.pj@sgi.com>
In-Reply-To: <1193670617.5035.38.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
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
	<1193670617.5035.38.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Maybe it's just me, but I think it's pretty presumptuous to think we can
> infer the intent of the application from the nodemask w/o additional
> flags such as Christoph proposed [cpuset relative]--especially for
> subsets of the cpuset.  E.g., the application could intend the nodemask
> to specify memories within a certain distance of a physical resource,
> such as where a particular IO adapter or set thereof attach to the
> platform.

Well, yes, we can't presume to know whether some application can move
or not.

But our kernel work is not presuming that.

It's providing mechanisms useful for moving apps.

The people using this decide what and when and if to move.

For example, the particular customers (HPC) I focus on for my job don't
move jobs because they don't want to take the transient performance
hit that would come from blowing out all their memory caches.

I'm guessing that David's situation involves something closer what you
see with a shared web hosting service, running jobs that are very
independent of hardware particulars.

But in any case, we (the kernel) are just providing the mechanisms.
If they don't fit ones needs, don't use them ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
