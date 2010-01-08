Return-Path: <linux-kernel-owner+w=401wt.eu-S1752269Ab0AHErR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0AHErR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 23:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012Ab0AHErQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 23:47:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:46043 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab0AHErQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 23:47:16 -0500
Date: Thu, 7 Jan 2010 20:49:40 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-ID: <20100107204940.253ed753@infradead.org>
In-Reply-To: <alpine.DEB.2.00.1001071025450.901@router.home>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105054536.44bf8002@infradead.org>
	<alpine.DEB.2.00.1001050916300.1074@router.home>
	<20100105192243.1d6b2213@infradead.org>
	<alpine.DEB.2.00.1001071007210.901@router.home>
	<alpine.LFD.2.00.1001070814080.7821@localhost.localdomain>
	<alpine.DEB.2.00.1001071025450.901@router.home>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 10:36:52 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
> > You're missing what Arjan said - the jav workload does a lot of
> > memory allocations too, causing mmap/munmap.
> 
> Well isnt that tunable on the app level? Get bigger chunks of memory
> in order to reduce the frequency of mmap operations? If you want
> concurrency of faults then mmap_sem write locking currently needs to
> be limited.

if an app has to change because our kernel sucks (for no good reason),
"change the app" really is the lame type of answer.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
