Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbZFZLgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbZFZLgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 07:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758442AbZFZLgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 07:36:40 -0400
Received: from mailhost13.gawab.com ([66.220.20.13]:56230 "HELO
	info15.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758292AbZFZLgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 07:36:38 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
Date: Fri, 26 Jun 2009 14:37:16 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <1245839904.3210.85.camel@localhost.localdomain> <200906252010.33535.a1426z@gawab.com> <20090626050245.GL31415@kernel.dk>
In-Reply-To: <20090626050245.GL31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906261437.16995.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jun 25 2009, Al Boldi wrote:
> > Jens Axboe wrote:
> > > The test case is random mmap writes to files that have been laid out
> > > sequentially. So it's all seeks. The target drive is an SSD disk
> > > though, so it doesn't matter a whole lot (it's a good SSD).
> >
> > Oh, SSD.  What numbers do you get for normal disks?
>
> I haven't run this particular test on rotating storage. The type of
> drive should not matter a lot, I'm mostly interested in comparing
> vanilla and the writeback patches on identical workloads and storage.

I think drive type matters a lot.  Access strategy on drives with high seek 
delays differs from those with no seek delays.  So it would probably be of 
interest to see this test run on rotating storage, unless the writeback 
patches are only meant for SSD?


Thanks!

--
Al

