Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbZIJQFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbZIJQFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbZIJQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:05:11 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:33524 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbZIJQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:05:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Bret Towe <magnade@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nikos Chantziaras <realnc@arcor.de>,
       Jens Axboe <jens.axboe@oracle.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <dda83e780909100902s32f076e7o87cebbbfc40d6dea@mail.gmail.com>
References: <20090908091304.GQ18599@kernel.dk>
	 <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu>
	 <1252486344.28645.18.camel@marge.simson.net>
	 <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk>
	 <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu>
	 <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu>
	 <dda83e780909100902s32f076e7o87cebbbfc40d6dea@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 18:05:09 +0200
Message-Id: <1252598709.7360.0.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 09:02 -0700, Bret Towe wrote:
> 
> thanks to this thread and others I've seen several kernel tunables
> that can effect how the scheduler performs/acts
> but what I don't see after a bit of looking is where all these are
> documented
> perhaps thats also part of the reason there are unhappy people with
> the current code in the kernel just because they don't know how
> to tune it for their workload

The thing is, ideally they should not need to poke at these. These knobs
are under CONFIG_SCHED_DEBUG, and that is exactly what they are for.

