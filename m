Return-Path: <linux-kernel-owner+w=401wt.eu-S1751820AbXB0UkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbXB0UkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbXB0UkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:40:17 -0500
Received: from brick.kernel.dk ([62.242.22.158]:3226 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbXB0UkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:40:15 -0500
Date: Tue, 27 Feb 2007 21:39:54 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Cfq  first request patch changes IO performance
Message-ID: <20070227203954.GI3733@kernel.dk>
References: <B41635854730A14CA71C92B36EC22AAC872B21@mssmsx411>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B41635854730A14CA71C92B36EC22AAC872B21@mssmsx411>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26 2007, Ananiev, Leonid I wrote:
> The patch "cfq-iosched: defer slice activation to first request being
> active"
> http://www.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=c
> ommitdiff;h=44f7c16065c83060cbb9dd9b367141682a6e2b8e;hp=99f9628aba4d8fb3
> b8d955c9efded0d0a1995fad
> 
> Sysbench fileio (random read/write mix)	-15%
> Tiobench sequential write		-3%
> Tiobench random write 			-5%
> Iozone record re-write			-21%
> Iozone mmap sequential read 		-20%
> Iozone mmap random write		+45%
> Aio-stress direct sequential read		+29%
> For other 3 tiobench, 7 aiostress and 13 iozone tests the result changes
> are less than variation.
> 
> Considered patch does not impact on performance if all threads have
> equal IO activity (tiobench).
> If single thread has IO activity the performance becomes unstable and is
> decreased mainly.

Yep there are a few unfortunate side effects, I have later fixed those.
I just need to split that patchset up and commit it.

-- 
Jens Axboe

