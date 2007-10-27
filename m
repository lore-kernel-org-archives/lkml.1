Return-Path: <linux-kernel-owner+w=401wt.eu-S1752820AbXJ0Cu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752820AbXJ0Cu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 22:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750875AbXJ0Cut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 22:50:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:52445 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750796AbXJ0Cus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 22:50:48 -0400
Date: Fri, 26 Oct 2007 19:50:48 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071026194144.6042316a.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710261949360.30293@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
 <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
 <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
 <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
 <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
 <20071026180713.aeedfac2.pj@sgi.com> <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
 <20071026194144.6042316a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> Christoph wrote:
> > Yes. We should default to Choice B. Add an option MPOL_MF_RELATIVE to 
> > enable that functionality? A new version of numactl can then enable
> > that by default for newer applications.
> 
> I'm confused.  If B is the default, then we don't need a flag to
> enable it, rather we need a flag to go back to the old choice A.

Dont we need it for numactl to preserve backward compatibility? numactl 
can set that flag by default for newer software. We likely need a new 
major release of numactl.
 
> Perhaps, either way, whatever compatibility flag we have should be
> something that can be forced on an application from the outside,
> perhaps as a per-system mode flag in /sys, or a per-cpuset mode flag,
> or a per-task operation, by what mechanism is not clear.

libnuma can take of that. But we need to have that flag for numactl to be 
backward compatible.

