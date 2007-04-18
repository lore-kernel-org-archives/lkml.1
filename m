Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbXDRBQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbXDRBQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 21:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDRBQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 21:16:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:7358 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753423AbXDRBQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 21:16:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,420,1170662400"; 
   d="scan'208"; a="229299790:sNHT16778979"
Date: Tue, 17 Apr 2007 18:14:45 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] slab: resize the alien caches too
Message-ID: <20070418011445.GB30721@linux-os.sc.intel.com>
References: <20070418004418.GA30721@linux-os.sc.intel.com> <Pine.LNX.4.64.0704171747130.2143@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704171747130.2143@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 05:48:30PM -0700, Christoph Lameter wrote:
> On Tue, 17 Apr 2007, Siddha, Suresh B wrote:
> 
> > While going through the slab code, I observed that alien caches are
> > not getting resized, when user changes the slab tunables. Appended patch
> > tries to fix this. Please review and let me know if I missed anything.
> 
> Let it be. We have not resized the alien caches ever and doing so may 
> cause serious memory usage. Size is hardcoded to 12 anyways.

hmm.. I see.

Let me do some experiments and getback to you(with what I am looking
exactly).

thanks,
suresh
