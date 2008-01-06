Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbYAFRw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbYAFRw5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 12:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbYAFRwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 12:52:50 -0500
Received: from waste.org ([66.93.16.53]:45656 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbYAFRws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 12:52:48 -0500
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
From: Matt Mackall <mpm@selenic.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zanussi@us.ibm.com
In-Reply-To: <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com>
	 <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com>
	 <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org>
	 <1199314218.4497.109.camel@cinder.waste.org>
	 <20080103085239.GA10813@elte.hu>
	 <1199378818.8274.25.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com>
	 <1199419890.4608.77.camel@cinder.waste.org>
	 <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Date: Sun, 06 Jan 2008 11:51:50 -0600
Message-Id: <1199641910.8215.28.camel@cinder.waste.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-05 at 18:21 +0200, Pekka J Enberg wrote:
> Hi Matt,
> 
> On Thu, 3 Jan 2008, Matt Mackall wrote:
> > >  SLUB can align these without a 2 byte 
> > > overhead. In some configurations this results in SLUB using even less 
> > > memory than SLOB. See f.e. Pekka's test at 
> > > http://marc.info/?l=linux-kernel&m=118405559214029&w=2
> > 
> > Available memory after boot is not a particularly stable measurement and
> > not valid if there's memory pressure. At any rate, I wasn't able to
> > reproduce this.
> 
> So, I have this silly memory profiler derived from the kleak patches by 
> the relayfs people and would love to try it out on an embedded workload 
> where SLUB memory footprint is terrible. Any suggestions?

Or you could use this (which is a bit broken on modern kernels, but
provides lots of interesting detail):

http://lwn.net/Articles/124374/

I don't have any particular "terrible" workloads for SLUB. But my
attempts to simply boot with all three allocators to init=/bin/bash in,
say, lguest show a fair margin for SLOB.

-- 
Mathematics is the supreme nostalgia of our time.

