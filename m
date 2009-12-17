Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZLQTze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZLQTze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:55:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZLQTzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:55:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36945 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbZLQTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:55:32 -0500
Date: Thu, 17 Dec 2009 20:55:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, minchan.kim@gmail.com
Subject: Re: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-ID: <20091217195530.GM9804@basil.fritz.box>
References: <20091216191312.f4655dac.kamezawa.hiroyu@jp.fujitsu.com> <20091216102806.GC15031@basil.fritz.box> <20091216193109.778b881b.kamezawa.hiroyu@jp.fujitsu.com> <1261004224.21028.500.camel@laptop> <20091217084046.GA9804@basil.fritz.box> <1261039534.27920.67.camel@laptop> <20091217085430.GG9804@basil.fritz.box> <20091217144551.GA6819@linux.vnet.ibm.com> <20091217175338.GL9804@basil.fritz.box> <20091217190804.GB6788@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217190804.GB6788@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 11:08:04AM -0800, Paul E. McKenney wrote:
> On Thu, Dec 17, 2009 at 06:53:39PM +0100, Andi Kleen wrote:
> > > OK, I have to ask...
> > > 
> > > Why not just use the already-existing SRCU in this case?
> > 
> > You right, SRCU could work. 
> > 
> > Still needs a lot more work of course.
> 
> As discussed with Peter on IRC, I have been idly thinking about how I
> would implement SRCU if I were starting on it today.  If you would like
> to see some specific improvements to SRCU, telling me about them would
> greatly increase the probability of my doing something about them.  ;-)

I think actual RCU improvements are pretty low on the list for this
one, so far we're not even completely sure how it would all work
on the high level.

mmap_sem is a nasty lock, handlings lots of different things.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
