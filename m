Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473Ab0AHAmH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab0AHAmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:42:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025Ab0AHAmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:42:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460Ab0AHAmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:42:05 -0500
Date: Thu, 7 Jan 2010 16:41:43 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
In-Reply-To: <alpine.LFD.2.00.1001071634500.7821@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1001071639560.7821@localhost.localdomain>
References: <20100104182429.833180340@chello.nl> <20100104182813.753545361@chello.nl> <20100105054536.44bf8002@infradead.org> <alpine.DEB.2.00.1001050916300.1074@router.home> <20100105192243.1d6b2213@infradead.org> <alpine.DEB.2.00.1001071007210.901@router.home>
 <alpine.LFD.2.00.1001070814080.7821@localhost.localdomain> <1262884960.4049.106.camel@laptop> <alpine.LFD.2.00.1001070934060.7821@localhost.localdomain> <alpine.LFD.2.00.1001070937180.7821@localhost.localdomain> <alpine.LFD.2.00.1001071031440.7821@localhost.localdomain>
 <1262900683.4049.139.camel@laptop> <alpine.LFD.2.00.1001071426590.7821@localhost.localdomain> <20100108092333.1040c799.kamezawa.hiroyu@jp.fujitsu.com> <alpine.LFD.2.00.1001071634500.7821@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Linus Torvalds wrote:
> 
>  - the patch I sent out just falls back to the old code if it finds 
>    something fishy, so it will do whatever do_brk() does regardless.

Btw, I'd like to state it again - the patch I sent out was not ready to be 
applied. I'm pretty sure it should check things like certain vm_flags 
too(VM_LOCKED etc), and fall back for those cases as well.

So the patch was more meant to illustrate the _concept_ than meant to 
necessarily be taken seriously as-is.

			Linus
