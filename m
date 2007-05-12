Return-Path: <linux-kernel-owner+w=401wt.eu-S1759134AbXELTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134AbXELTVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbXELTVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:21:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbXELTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:21:34 -0400
Date: Sat, 12 May 2007 21:21:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
Message-ID: <20070512192130.GA8833@one.firstfloor.org>
References: <20070511131541.992688403@chello.nl> <20070511132321.895740140@chello.nl> <20070511093108.495feb70.akpm@linux-foundation.org> <Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com> <20070511110522.ed459635.akpm@linux-foundation.org> <p73odkpeusf.fsf@bingen.suse.de> <20070512181254.GA331@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512181254.GA331@tv-sign.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This also allows us to de-uglify workqueue.c a little bit, it uses
> a home-grown cpu_populated_map.

It might be obsolete iff more and more architecture don't use NR_CPUS filled
possible_map anymore (haven't checked them all to know if it's true or not)

If not there are a couple of more optimizations that can be done, e.g.
in networking by converting more code to hotplug notifier.

-Andi
