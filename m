Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752456AbYLQRVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbYLQRVA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 12:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751365AbYLQRUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 12:20:48 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:54808 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbYLQRUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 12:20:48 -0500
Date: Wed, 17 Dec 2008 09:15:42 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Message-ID: <20081217171542.GC6674@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com> <20081216193648.GJ6681@linux.vnet.ibm.com> <1229507096.32517.8.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229507096.32517.8.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 09:44:56AM +0000, Catalin Marinas wrote:
> On Tue, 2008-12-16 at 11:36 -0800, Paul E. McKenney wrote:
> > On Wed, Dec 10, 2008 at 06:26:59PM +0000, Catalin Marinas wrote:
> > > This patch adds the base support for the kernel memory leak
> > > detector. It traces the memory allocation/freeing in a way similar to
> > > the Boehm's conservative garbage collector, the difference being that
> > > the unreferenced objects are not freed but only shown in
> > > /sys/kernel/debug/memleak. Enabling this feature introduces an
> > > overhead to memory allocations.
> > 
> > Looks good to me from an RCU viewpoint!
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks for reviewing it.
> 
> FYI, in the version I'm going to post this week I added another mutex to
> ensure the exclusive opening of the /sys/kernel/debug/memleak file as
> one can now use this file to configure kmemleak at run-time. The RCU
> locking isn't affected and I'll add your "Reviewed-by:" line.

Fair enough!

						Thanx, Paul
