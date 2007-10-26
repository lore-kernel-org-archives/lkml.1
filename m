Return-Path: <linux-kernel-owner+w=401wt.eu-S1765972AbXJZVR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765972AbXJZVR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762224AbXJZVRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:17:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37666 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757408AbXJZVRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:17:19 -0400
Date: Fri, 26 Oct 2007 14:17:18 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: David Rientjes <rientjes@google.com>, Paul Jackson <pj@sgi.com>,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <1193433239.5032.95.camel@localhost>
Message-ID: <Pine.LNX.4.64.0710261415580.18139@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
  <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com> 
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com> 
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com> 
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com> 
 <20071025185506.8c373aa8.pj@sgi.com>  <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
  <1193412644.5032.13.camel@localhost>  <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
  <20071026120037.7b95a136.pj@sgi.com>  <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
 <1193433239.5032.95.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Lee Schermerhorn wrote:

> For some systems [not mine], the nodemasks can get quite large.  I have
> a patch, that I've tested  atop Mel Gorman's "onezonelist" patches that
> replaces the nodemasks embedded in struct mempolicy with pointers to
> dynamically allocated ones.  However, it's probably not much of a win,
> memorywise, if most of the uses are for interleave and bind
> policies--both of which would always need the nodemasks in addition to
> the pointers.
> 
> Now, if we could replace the 'cpuset_mems_allowed' nodemask with a
> pointer to something stable, it might be a win.

The memory policies are already shared and have refcounters for that 
purpose.
