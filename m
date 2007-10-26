Return-Path: <linux-kernel-owner+w=401wt.eu-S1765064AbXJZV1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765064AbXJZV1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbXJZV07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:26:59 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:42794 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbXJZV06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:26:58 -0400
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0710261415580.18139@schroedinger.engr.sgi.com>
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
	 <Pine.LNX.4.64.0710261415580.18139@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 26 Oct 2007 17:26:31 -0400
Message-Id: <1193433992.5032.102.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 14:17 -0700, Christoph Lameter wrote:
> On Fri, 26 Oct 2007, Lee Schermerhorn wrote:
> 
> > For some systems [not mine], the nodemasks can get quite large.  I have
> > a patch, that I've tested  atop Mel Gorman's "onezonelist" patches that
> > replaces the nodemasks embedded in struct mempolicy with pointers to
> > dynamically allocated ones.  However, it's probably not much of a win,
> > memorywise, if most of the uses are for interleave and bind
> > policies--both of which would always need the nodemasks in addition to
> > the pointers.
> > 
> > Now, if we could replace the 'cpuset_mems_allowed' nodemask with a
> > pointer to something stable, it might be a win.
> 
> The memory policies are already shared and have refcounters for that 
> purpose.

I must have missed that in the code I'm reading :)

Have a nice weekend.

Lee



