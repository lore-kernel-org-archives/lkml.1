Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZKWVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZKWVCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 16:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbZKWVCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 16:02:47 -0500
Received: from waste.org ([173.11.57.241]:34247 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbZKWVCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 16:02:47 -0500
Subject: Re: lockdep complaints in slab allocator
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <1259006475.15619.16.camel@penberg-laptop>
References: <20091118181202.GA12180@linux.vnet.ibm.com>
	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop>  <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <alpine.DEB.2.00.0911231329560.5617@router.home>
	 <1259005814.15619.14.camel@penberg-laptop>
	 <1259006475.15619.16.camel@penberg-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Nov 2009 15:01:57 -0600
Message-ID: <1259010117.17871.473.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 22:01 +0200, Pekka Enberg wrote:
> On Mon, 2009-11-23 at 21:50 +0200, Pekka Enberg wrote:
> > On Mon, 23 Nov 2009, Pekka Enberg wrote:
> > > > That turns out to be _very_ hard. How about something like the following
> > > > untested patch which delays slab_destroy() while we're under nc->lock.
> > 
> > On Mon, 2009-11-23 at 13:30 -0600, Christoph Lameter wrote:
> > > Code changes to deal with a diagnostic issue?
> > 
> > OK, fair enough. If I suffer permanent brain damage from staring at the
> > SLAB code for too long, I hope you and Matt will chip in to pay for my
> > medication.

You Europeans and your droll health care jokes.

> Maybe something like this untested patch fixes the issue...

This looks like a much better approach.

-- 
http://selenic.com : development and support for Mercurial and Linux


