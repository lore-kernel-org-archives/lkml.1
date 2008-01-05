Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYAERMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYAERMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 12:12:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYAERMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 12:12:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57800 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYAERMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 12:12:35 -0500
Date: Sat, 5 Jan 2008 18:14:40 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, Christoph Lameter <clameter@sgi.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       zanussi@us.ibm.com
Subject: Re: [PATCH] procfs: provide slub's /proc/slabinfo
Message-ID: <20080105171440.GA4137@one.firstfloor.org>
References: <Pine.LNX.4.64.0801021830160.6823@blonde.wat.veritas.com> <84144f020801021109v78e06c6k10d26af0e330fc85@mail.gmail.com> <alpine.LFD.1.00.0801021130210.32517@woody.linux-foundation.org> <1199314218.4497.109.camel@cinder.waste.org> <20080103085239.GA10813@elte.hu> <1199378818.8274.25.camel@cinder.waste.org> <Pine.LNX.4.64.0801031808470.7244@schroedinger.engr.sgi.com> <1199419890.4608.77.camel@cinder.waste.org> <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801051816490.22821@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So, I have this silly memory profiler derived from the kleak patches by 
> the relayfs people and would love to try it out on an embedded workload 
> where SLUB memory footprint is terrible. Any suggestions?

FWIW this can be all done in a few lines of systemtap. The only
change needed to the kernel is to not inline kmalloc().

-Andi
