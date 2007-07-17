Return-Path: <linux-kernel-owner+w=401wt.eu-S933011AbXGQBMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011AbXGQBMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 21:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbXGQBMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 21:12:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38780 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXGQBMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 21:12:33 -0400
Message-ID: <469C177A.3080002@garzik.org>
Date: Mon, 16 Jul 2007 21:12:26 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: block/bsg.c
References: <20070716165706.348f6bbf.akpm@linux-foundation.org>	<469C11B1.8000302@garzik.org>	<20070716175347.bea345dd.akpm@linux-foundation.org>	<469C1423.3090908@garzik.org> <20070716180908.e15325bd.akpm@linux-foundation.org>
In-Reply-To: <20070716180908.e15325bd.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Yup, but the concern (from Al, iirc) was that someone could change the code
> later on, add a new bug and have that bug hidden by the unneeded
> initialisation.

True.

That's why #gccbug went the safe route, took the cost of extra 
instructions, and initialized it to zero.


> uninitialized_var() has the advantage that it generates no code, whereas "=
> 0" often adds instructions.  Plus of course it is self-documenting, greppable-for
> and centrally alterable.

Agreed.

	Jeff


