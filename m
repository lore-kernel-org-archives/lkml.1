Return-Path: <linux-kernel-owner+w=401wt.eu-S1763578AbXJZPid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763578AbXJZPid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 11:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbXJZPi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 11:38:26 -0400
Received: from atlrel8.hp.com ([156.153.255.206]:50250 "EHLO atlrel8.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753334AbXJZPiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 11:38:25 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk-manpages@gmx.net>
In-Reply-To: <alpine.DEB.0.9999.0710252049590.18868@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <20071025192945.82962eea.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
	 <20071025201455.acb4e72c.pj@sgi.com>
	 <alpine.DEB.0.9999.0710252049590.18868@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 11:37:34 -0400
Message-Id: <1193413054.5032.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 20:58 -0700, David Rientjes wrote:
> On Thu, 25 Oct 2007, Paul Jackson wrote:
> 
> > The user space man pages for set_mempolicy(2) are now even more
> > behind the curve, by not mentioning that MPOL_INTERLEAVE's mask
> > might mean nothing, if (1) in a cpuset marked memory_spread_user,
> > (2) after the cpuset has changed 'mems'.
> > 
> 
> Yeah.  They were already outdated in the sense that they did not specify 
> that the interleave nodemask could change as a result of a cpuset mems 
> change.
> 
> > I wonder if there is any way to fix that.  Who does the man pages
> > for Linux system calls?
> > 

Michael Kerrisk, whom I've copied, does.  I recently sent in an update
to all of the mempolicy man pages that describe the behavior as it
currently exists.  [I need to send in an update for
MPOL_F_MEMS_ALLOWED].

One of the things that has bothered me is that there are no cpuset man
pages to reference from the mempolicy man pages.  [I know, we can and do
refer to the kernel source Documentation, but that might not be
available to everyone w/o some digging.  "See Also" refs typically point
at other man pages...].  To get around this, I had to talk about "nodes
allowed in the current context" or some such weasel-wording in my
updates.

Paul:  what do you think about subsetting the cpuset.txt into a man page
or 2 that can be referenced by other man pages' See Also sections?

> 
<snip>
> 
> 		David

Lee

