Return-Path: <linux-kernel-owner+w=401wt.eu-S1763340AbXJ0B0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763340AbXJ0B0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 21:26:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXJ0B0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 21:26:15 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53437 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751401AbXJ0B0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 21:26:14 -0400
Date: Fri, 26 Oct 2007 18:26:13 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Paul Jackson <pj@sgi.com>
cc: David Rientjes <rientjes@google.com>, Lee.Schermerhorn@hp.com,
       akpm@linux-foundation.org, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
In-Reply-To: <20071026180713.aeedfac2.pj@sgi.com>
Message-ID: <Pine.LNX.4.64.0710261823210.30012@schroedinger.engr.sgi.com>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
 <alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
 <alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
 <Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
 <20071025185506.8c373aa8.pj@sgi.com> <alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
 <1193412644.5032.13.camel@localhost> <alpine.DEB.0.9999.0710261145400.11674@chino.kir.corp.google.com>
 <20071026120037.7b95a136.pj@sgi.com> <alpine.DEB.0.9999.0710261344180.6249@chino.kir.corp.google.com>
 <1193433239.5032.95.camel@localhost> <alpine.DEB.0.9999.0710261416160.11594@chino.kir.corp.google.com>
 <1193434278.5032.106.camel@localhost> <alpine.DEB.0.9999.0710261436140.16966@chino.kir.corp.google.com>
 <20071026180713.aeedfac2.pj@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Paul Jackson wrote:

> Choice B lets the task calculate its mempolicy mask as if it owned
> the entire system, and express whatever elaborate mempolicy placement
> it might need, when blessed with enough memory nodes to matter.
> The system would automatically scrunch that request down to whatever
> is the current size and placement of the cpuset holding that task.
> 
> Given a clean slate, I prefer Choice B.

Yes. We should default to Choice B. Add an option MPOL_MF_RELATIVE to 
enable that functionality? A new version of numactl can then enable
that by default for newer applications.
