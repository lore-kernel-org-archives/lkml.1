Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbXEJOWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbXEJOWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbXEJOWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:22:25 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:39447 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbXEJOWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:22:24 -0400
Date: Thu, 10 May 2007 16:17:57 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Heinz Mauelshagen <hjm@redhat.com>
Subject: Re: [2.6.22 PATCH 22/26] dm: bio list helpers
In-Reply-To: <20070509064923.GO4163@kernel.dk>
Message-ID: <Pine.LNX.4.61.0705101617170.32349@yvahk01.tjqt.qr>
References: <20070508194845.GC24114@agk.fab.redhat.com>
 <20070508174159.7d78a275.akpm@linux-foundation.org> <20070509064923.GO4163@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 9 2007 08:49, Jens Axboe wrote:
>On Tue, May 08 2007, Andrew Morton wrote:
>> > +#define bio_list_for_each(bio, bl) \
>> > +	for (bio = (bl)->head; bio && ({ prefetch(bio->bi_next); 1; }); \
>> > +	     bio = bio->bi_next)
>> > +
>
>Besides, manual prefetching is very rarely a win. I dabbled with some
>benchmarks a few weeks back (with the doubly linked lists), and in most
>cases it was actually a loss. So I'd vote for just removing the
>prefetch() above.

So is the prefetching in the basic ADTs (e.g. linux/list.h) a loss too?



	Jan
-- 
