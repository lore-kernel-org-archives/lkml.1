Return-Path: <linux-kernel-owner+w=401wt.eu-S1755530AbYIEINI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbYIEINI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 04:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbYIEIMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 04:12:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52482 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYIEIMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 04:12:53 -0400
Date: Fri, 5 Sep 2008 10:12:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] lockstat: documentation update
Message-ID: <20080905081241.GE12409@elte.hu>
References: <1220450457.8609.150.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220450457.8609.150.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> Christoph noted that the documentation doesn't tell in what unit the
> lockstat times are reported, ammend this.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

applied the commit below to tip/core/locking, thanks!

	Ingo

------------->
>From cdad72207d164569cb4bf647eb824a7f93e8d388 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 3 Sep 2008 16:00:57 +0200
Subject: [PATCH] lockstat: documentation update

Christoph noted that the documentation doesn't tell in what unit the
lockstat times are reported, ammend this.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 Documentation/lockstat.txt |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 4ba4664..02f36f5 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -100,6 +100,7 @@ The first lock (05-10) is a read/write lock, and shows two lines above the
 short separator. The contention points don't match the column descriptors,
 they have two: contentions and [<IP>] symbol.
 
+The integer part of the time values is in us.
 
 View the top contending locks:
 
