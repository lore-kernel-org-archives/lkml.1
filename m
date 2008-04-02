Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYDBHZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYDBHZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754104AbYDBHZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:25:01 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15410 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbYDBHZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:25:00 -0400
Date: Wed, 2 Apr 2008 09:24:57 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: kmemcheck caught read from freed memory (cfq_free_io_context)
Message-ID: <20080402072456.GI12774@kernel.dk>
References: <19f34abd0804011408v19e13b6cje1ca89a2a471484c@mail.gmail.com> <1207085788.29991.6.camel@lappy> <20080402071709.GC12774@kernel.dk> <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804021020280.25738@sbz-30.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02 2008, Pekka J Enberg wrote:
> On Wed, 2 Apr 2008, Jens Axboe wrote:
> > Good catch, I wonder why it didn't complain in my testing. I've added a
> > patch to fix that, please see it here:
> 
> You probably don't have kmemcheck in your kernel ;-)

Ehm no, you are right :)

-- 
Jens Axboe

