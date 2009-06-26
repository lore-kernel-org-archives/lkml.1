Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbZFZFCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbZFZFCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751026AbZFZFCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:02:43 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50133 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbZFZFCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:02:43 -0400
Date: Fri, 26 Jun 2009 07:02:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Al Boldi <a1426z@gawab.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
Message-ID: <20090626050245.GL31415@kernel.dk>
References: <1245839904.3210.85.camel@localhost.localdomain> <200906251646.22785.a1426z@gawab.com> <20090625144450.GT31415@kernel.dk> <200906252010.33535.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906252010.33535.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25 2009, Al Boldi wrote:
> Jens Axboe wrote:
> > The test case is random mmap writes to files that have been laid out
> > sequentially. So it's all seeks. The target drive is an SSD disk though,
> > so it doesn't matter a whole lot (it's a good SSD).
> 
> Oh, SSD.  What numbers do you get for normal disks?

I haven't run this particular test on rotating storage. The type of
drive should not matter a lot, I'm mostly interested in comparing
vanilla and the writeback patches on identical workloads and storage.

-- 
Jens Axboe

