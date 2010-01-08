Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925Ab0AHSq1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab0AHSq1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 13:46:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885Ab0AHSq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 13:46:27 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38389 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab0AHSq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 13:46:26 -0500
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
From: Andi Kleen <andi@firstfloor.org>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	<20100105134357.4bfb4951.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001042052210.3630@localhost.localdomain>
	<20100105143046.73938ea2.kamezawa.hiroyu@jp.fujitsu.com>
	<20100105163939.a3f146fb.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001050707520.3630@localhost.localdomain>
	<20100106092212.c8766aa8.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001051718100.3630@localhost.localdomain>
	<20100106115233.5621bd5e.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001051917000.3630@localhost.localdomain>
	<20100106125625.b02c1b3a.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.LFD.2.00.1001052007090.3630@localhost.localdomain>
	<1262969610.4244.36.camel@laptop>
	<alpine.LFD.2.00.1001080911340.7821@localhost.localdomain>
	<alpine.DEB.2.00.1001081138260.23727@router.home>
Date: Fri, 08 Jan 2010 19:46:20 +0100
In-Reply-To: <alpine.DEB.2.00.1001081138260.23727@router.home> (Christoph Lameter's message of "Fri, 8 Jan 2010 11:43:41 -0600 (CST)")
Message-ID: <87my0omo3n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <cl@linux-foundation.org> writes:

> Can we at least consider a typical standard business server, dual quad
> core hyperthreaded with 16 "cpus"? Cacheline contention will increase
> significantly there.

This year's standard server will be more like 24-64 "cpus"

Cheating with locks usually doesn't work anymore at these sizes.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
