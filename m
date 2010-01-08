Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411Ab0AHT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab0AHT2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 14:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161Ab0AHT2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 14:28:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36831 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0AHT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 14:28:17 -0500
Date: Fri, 8 Jan 2010 20:28:15 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100108192815.GB14141@basil.fritz.box>
References: <20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001051917000.3630@localhost.localdomain> <20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001052007090.3630@localhost.localdomain> <1262969610.4244.36.camel@laptop> <alpine.LFD.2.00.1001080911340.7821@localhost.localdomain> <alpine.DEB.2.00.1001081138260.23727@router.home> <87my0omo3n.fsf@basil.nowhere.org> <alpine.DEB.2.00.1001081255100.26886@router.home> <alpine.LFD.2.00.1001081102120.7821@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001081102120.7821@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 11:11:32AM -0800, Linus Torvalds wrote:
> 
> 
> On Fri, 8 Jan 2010, Christoph Lameter wrote:
> 
> > On Fri, 8 Jan 2010, Andi Kleen wrote:
> > 
> > > This year's standard server will be more like 24-64 "cpus"
> > 
> > What will it be? 2 or 4 sockets?
> 
> I think we can be pretty safe in saying that two sockets is going to be 
> overwhelmingly the more common case.

With 24 CPU threads cheating is very difficult too.

Besides even the "uncommon" part of a large pie can be still a lot of systems.

-Andi

