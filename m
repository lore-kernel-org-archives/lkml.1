Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694Ab0AEGMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0AEGMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 01:12:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910Ab0AEGMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 01:12:55 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43533 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0AEGMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 01:12:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Jan 2010 15:09:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 6/8] mm: handle_speculative_fault()
Message-Id: <20100105150932.ab2e6820.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <28c262361001042209k7241dd38l3d51d230e7b68a5@mail.gmail.com>
References: <20100104182429.833180340@chello.nl>
	<20100104182813.753545361@chello.nl>
	<20100105092559.1de8b613.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262361001042029w4b95f226lf54a3ed6a4291a3b@mail.gmail.com>
	<alpine.LFD.2.00.1001042038110.3630@localhost.localdomain>
	<28c262361001042209k7241dd38l3d51d230e7b68a5@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jan 2010 15:09:47 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:
> My humble opinion is following as.
> 
> Couldn't we synchronize rcu in that cases(munmap, exit and so on)?
> It can delay munap and exit but it would be better than handling them by more
> complicated things, I think. And both cases aren't often cases so we
> can achieve advantage than disadvantage?
> 

In most case, a program is single threaded. And sychronize_rcu() in unmap path
just adds very big overhead.

Thanks,
-Kame

