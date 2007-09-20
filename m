Return-Path: <linux-kernel-owner+w=401wt.eu-S1759791AbXITRxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759791AbXITRxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757919AbXITRxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:53:07 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50903 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752042AbXITRxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:53:03 -0400
Date: Thu, 20 Sep 2007 10:53:02 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Mel Gorman <mel@skynet.ie>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew.R.wilcox@intel.com
Subject: Re: tbench regression - Why process scheduler has impact on tbench
 and why small per-cpu slab (SLUB) cache creates the scenario?
In-Reply-To: <20070919021705.GB20863@linux-os.sc.intel.com>
Message-ID: <Pine.LNX.4.64.0709201051350.8509@schroedinger.engr.sgi.com>
References: <1188953218.26438.34.camel@ymzhang> <200709100810.46341.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709101201140.24491@schroedinger.engr.sgi.com>
 <200709110117.57387.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0709111314190.25781@schroedinger.engr.sgi.com>
 <20070913060432.GB6078@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0709131055430.8859@schroedinger.engr.sgi.com>
 <20070914191511.GC6078@linux-os.sc.intel.com>
 <Pine.LNX.4.64.0709141242200.17369@schroedinger.engr.sgi.com>
 <20070919021705.GB20863@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, Siddha, Suresh B wrote:

> For now, we are trying to do slab Vs slub comparisons for the mainline kernels.
> Let's see how that goes.
> 
> Meanwhile, any chance that you can point us at relevant recent patches/fixes
> that are in -mm and perhaps that can be applied to mainline kernel?

Those can be found in the performance branch of the slab git tree.

See 
http://git.kernel.org/?p=linux/kernel/git/christoph/slab.git;a=log;h=performance
