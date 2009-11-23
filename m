Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbZKWTnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbZKWTnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754499AbZKWTna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:43:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47127 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZKWTna (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 14:43:30 -0500
Date: Mon, 23 Nov 2009 11:43:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
       mpm@selenic.com, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
Message-ID: <20091123194334.GD6774@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091118181202.GA12180@linux.vnet.ibm.com> <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258709153.11284.429.camel@laptop> <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com> <1258714328.11284.522.camel@laptop> <4B067816.6070304@cs.helsinki.fi> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <alpine.DEB.2.00.0911231329560.5617@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911231329560.5617@router.home>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 01:30:50PM -0600, Christoph Lameter wrote:
> On Mon, 23 Nov 2009, Pekka Enberg wrote:
> 
> > That turns out to be _very_ hard. How about something like the following
> > untested patch which delays slab_destroy() while we're under nc->lock.
> 
> Code changes to deal with a diagnostic issue?

Indeed!  At least if we want the diagnostics to have any value, we do
need to avoid false alarms.  Same reasoning as for gcc warnings, right?

							Thanx, Paul
