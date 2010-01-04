Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420Ab0ADVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0ADVrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767Ab0ADVrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:47:15 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54370 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab0ADVrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:47:14 -0500
Subject: Re: [RFC][PATCH 0/8] Speculative pagefault -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
       cl@linux-foundation.org, "hugh.dickins" <hugh.dickins@tiscali.co.uk>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <4B42606F.3000906@redhat.com>
References: <20100104182429.833180340@chello.nl>
	 <4B42606F.3000906@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jan 2010 22:46:13 +0100
Message-ID: <1262641573.6408.434.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-04 at 16:41 -0500, Rik van Riel wrote:
> On 01/04/2010 01:24 PM, Peter Zijlstra wrote:
> > Patch series implementing speculative page faults for x86.
> 
> Fun, but why do we need this?

People were once again concerned with mmap_sem contention on threaded
apps on large machines. Kame-san posted some patches, but I felt they
weren't quite crazy enough ;-)

> What improvements did you measure?

I got it not to crash :-) Although I'd not be surprised if other people
do manage, it needs more eyes.

> I'll take a look over the patches to see whether they're
> sane...

More appreciated, thanks!

