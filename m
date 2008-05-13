Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYEMM7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYEMM7l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 08:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756924AbYEMM7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 08:59:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53015 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010AbYEMM7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 08:59:32 -0400
Message-ID: <482990AB.7070905@firstfloor.org>
Date: Tue, 13 May 2008 14:59:23 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Johannes Weiner <hannes@saeurebad.de>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/3] bootmem2 III
References: <20080509151713.939253437@saeurebad.de>	<20080509184044.GA19109@one.firstfloor.org>	<87lk2gtzta.fsf@saeurebad.de> <48275493.40601@firstfloor.org> <874p92qsvn.fsf@saeurebad.de>
In-Reply-To: <874p92qsvn.fsf@saeurebad.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I was wondering yesterday if it would be feasible to enforce
> contiguousness for nodes.

And lose the memory? That would make people not happy.

  So that arch-code does not create one pgdat
> for each node but one for each contiguous block.  I have not yet looked
> deeper into it, but I suspect that other mm code has similar problems
> with nodes spanning other nodes.

I wouldn't think so. At least sparse memory with large holes is not that
uncommon in the non x86 world.

-Andi

