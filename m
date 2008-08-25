Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYHYGxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYHYGxY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 02:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYHYGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 02:53:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbYHYGxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 02:53:15 -0400
Subject: Re: Upcoming oops in lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: peterz@infradeads.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20080823134955.07096e34@infradead.org>
References: <20080823134955.07096e34@infradead.org>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:51:57 +0200
Message-Id: <1219647117.20732.18.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-23 at 13:49 -0700, Arjan van de Ven wrote:
> in kerneloops.org a crash (slab poison) in mark_lock is coming up
> rapidly: 
> 
> http://www.kerneloops.org/searchweek.php?search=mark_lock
> 
> and despite a few earlier hits on the same function it seems to be
> something introduced in 2.6.27-rc... (the older ones aren't slab poison)

infradeads.org hehe

can this crash be reproduced without lockdep? Normally when I see
crashes like this its crashing because the lock itself is stomped on
(use after free, for example), and lockdep happens to be the one to
touch it first (the lockdep state is by far the largest bit of the
spinlock data too).


