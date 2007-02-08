Return-Path: <linux-kernel-owner+w=401wt.eu-S1423510AbXBHTJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423510AbXBHTJx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423508AbXBHTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:09:53 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:45834 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423510AbXBHTJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:09:52 -0500
Date: Thu, 8 Feb 2007 11:09:40 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, GOTO <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [2.6.20][PATCH] fix mempolicy error check on a system with
 memory-less-node
In-Reply-To: <20070207094344.0efdde10.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0702081106460.11045@schroedinger.engr.sgi.com>
References: <20070206202312.4f979bcf.kamezawa.hiroyu@jp.fujitsu.com>
 <p73ejp2mfqh.fsf@bingen.suse.de> <20070207082330.d07525ec.akpm@linux-foundation.org>
 <200702071750.55283.ak@suse.de> <20070207094344.0efdde10.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Feb 2007, Andrew Morton wrote:

> > > A node which has CPUs and no memory is obviously physically possible and
> > > isn't a completely insane thing for a user to do.  I'd have thought that
> > > the kernel should be able to cleanly and clearly handle it,
> > 
> > It doesn't.
> 
> Fix it?

Why? It is a bad idea.
 
> > > and to 
> > > accurately present the machine's topology to the user without us having to
> > > go adding falsehoods like this?
> > 
> > a node is a piece of memory. Without memory it doesn't make sense.
> 
> Who said?  I can pick up a piece of circuitry which has four CPUs and no
> RAM, wave it about then stick it in a computer.  The kernel is just wrong,
> surely?

Surely your computer has some memory so attach it to that memory (which 
in a NUMA system would be one or the other node).

Cpu only "nodes" would mean that all memory would be off node. Meaning 
whatever interconnect one has would be heavily used. Operating system and 
application performance will suffer.


