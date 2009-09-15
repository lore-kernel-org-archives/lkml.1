Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZIOKN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZIOKN2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 06:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZIOKNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 06:13:24 -0400
Received: from brick.kernel.dk ([93.163.65.50]:40146 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZIOKNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 06:13:24 -0400
Date: Tue, 15 Sep 2009 12:13:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] block: remove
	blk_iopoll_enabled
Message-ID: <20090915101326.GH23126@kernel.dk>
References: <20090913175902.GP14984@kernel.dk> <20090915092822.GA15538@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915092822.GA15538@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Ingo Molnar wrote:
> 
> Note, upstream now breaks the build occasionally if CONFIG_BLOCK is 
> disabled:
> 
>  kernel/built-in.o:(.data+0x17b0): undefined reference to `blk_iopoll_enabled'
> 
> Kamalesh Babulal posted a fix for that two weeks ago, i suspect it 
> should be picked up - find it below.

Ugh, apparently I fixed that up in the original branch but didn't
propagate that to my for-2.6.32 branch. Will get this fixed up.

-- 
Jens Axboe

