Return-Path: <linux-kernel-owner+w=401wt.eu-S1764626AbXJZUoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764626AbXJZUoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXJZUoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:44:04 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:39299 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbXJZUoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:44:02 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	 <20071025185506.8c373aa8.pj@sgi.com>
	 <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	 <1193412644.5032.13.camel@localhost>
	 <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 16:43:24 -0400
Message-Id: <1193431405.5032.65.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 11:46 -0700, David Rientjes wrote:
> On Fri, 26 Oct 2007, Lee Schermerhorn wrote:
> 
> > Actually, my patch doesn't change the set_mempolicy() API at all, it
> > just co-opts a currently unused/illegal value for the nodemask to
> > indicate "all allowed nodes".  Again, I need to provide a libnuma API to
> > request this.   Soon come, mon...
> > 
> 
> If something that was previously unaccepted is now allowed with a 
> newly-introduced semantic, that's an API change.

Well, it's an extension for sure, but a backward compatible one.  It
should not affect any correct existing application--i.e., one that
checks it's return status--except maybe the odd test program that needs
to be updated to handle the new semantics.  We're allowed to extend APIs
as long as we don't break correct applications, right?

I mean, it's not like it's a new argument or such.

Lee


