Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924Ab0AEAcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0AEAcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:32:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045Ab0AEAb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:31:58 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35002 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0AEAb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:31:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 5 Jan 2010 09:28:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 0/8] Speculative pagefault -v3
Message-Id: <20100105092836.a7feb26c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1001041558350.17041@router.home>
References: <20100104182429.833180340@chello.nl>
	<4B42606F.3000906@redhat.com>
	<alpine.DEB.2.00.1001041558350.17041@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010 15:59:45 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Mon, 4 Jan 2010, Rik van Riel wrote:
> 
> > Fun, but why do we need this?
> >
> > What improvements did you measure?
> 
> If it measures up to Kame-sans approach then the possible pagefault rate
> will at least double ...
> 
On 4-core/2 socket machine ;)

More than page fault rate, important fact is that we can reduce cache contention
by skipping mmap_sem in some situation.

And I think we have some chances.

Thanks,
-Kame

