Return-Path: <linux-kernel-owner+w=401wt.eu-S1753603AbXJ0Clz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbXJ0Clz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 22:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbXJ0Clr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 22:41:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:48745 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751812AbXJ0Clr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 22:41:47 -0400
Date: Fri, 26 Oct 2007 19:41:44 -0700
From: Paul Jackson <pj@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: rientjes@google.com, Lee.Schermerhorn@hp.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071026194144.6042316a.pj@sgi.com>
In-Reply-To: <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
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
	<20071026180713.aeedfac2.pj@sgi.com>
	<Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph wrote:
> Yes. We should default to Choice B. Add an option MPOL_MF_RELATIVE to 
> enable that functionality? A new version of numactl can then enable
> that by default for newer applications.

I'm confused.  If B is the default, then we don't need a flag to
enable it, rather we need a flag to go back to the old choice A.

So are you saying that:
 1) Choice A remains the default for the kernel unless
    MPOL_MF_RELATIVE is added, or
 2) that the new default for the kernel is Choice B,
    unless MPOL_MF_RELATIVE is specified, asking to
    revert to the original Choice A behaviour?

Perhaps, either way, whatever compatibility flag we have should be
something that can be forced on an application from the outside,
perhaps as a per-system mode flag in /sys, or a per-cpuset mode flag,
or a per-task operation, by what mechanism is not clear.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
