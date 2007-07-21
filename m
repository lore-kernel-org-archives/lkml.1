Return-Path: <linux-kernel-owner+w=401wt.eu-S935295AbXGUGR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935295AbXGUGR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 02:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756215AbXGUGRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 02:17:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48337 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbXGUGRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 02:17:21 -0400
Date: Sat, 21 Jul 2007 08:17:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] compacting file_ra_state
Message-ID: <20070721061720.GA5293@one.firstfloor.org>
References: <20070721035733.951838089@mail.ustc.edu.cn> <20070721035850.977231489@mail.ustc.edu.cn> <384990797.09024@ustc.edu.cn> <alpine.LFD.0.999.0707202126250.27249@woody.linux-foundation.org> <20070721055706.GA5097@one.firstfloor.org> <alpine.LFD.0.999.0707202312260.27249@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707202312260.27249@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 11:13:34PM -0700, Linus Torvalds wrote:
> > I thought the new patches were some some restructured code, but 
> > essentially the tested algorithms?
> 
> No, this series is a further cleanup on top of the restructured code, with 
> some new features too. The series _looks_ fine to me, but it still makes 
> sense to go through -mm, I think.

What I meant was:

iirc he first had a "very complex" patchkit in -mm* (the one 
with multiple predictors working together); then that got then replaced
with a simpler easier to review one and now he's feeding the stuff from
the complex one piece by piece back.

Just pointed out that the newer stuff was likely already in -mm* for some
time, just before one of the simplifications.

But I guess more testing cannot hurt anyways.

Anyways it's good we're finally making forward progress on this. It has 
the potential for real nice performance gains.

-Andi
