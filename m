Return-Path: <linux-kernel-owner+w=401wt.eu-S1755245AbZFYRJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbZFYRJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbZFYRJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:09:25 -0400
Received: from mailhost14.gawab.com ([66.220.20.14]:44060 "HELO
	info88.gawab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754149AbZFYRJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:09:24 -0400
X-Trusted: Whitelisted
From: Al Boldi <a1426z@gawab.com>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] mm: stop balance_dirty_pages doing too much work
Date: Thu, 25 Jun 2009 20:10:33 +0300
User-Agent: KMail/1.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Richard Kennedy <richard@rsk.demon.co.uk>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <1245839904.3210.85.camel@localhost.localdomain> <200906251646.22785.a1426z@gawab.com> <20090625144450.GT31415@kernel.dk>
In-Reply-To: <20090625144450.GT31415@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252010.33535.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> The test case is random mmap writes to files that have been laid out
> sequentially. So it's all seeks. The target drive is an SSD disk though,
> so it doesn't matter a whole lot (it's a good SSD).

Oh, SSD.  What numbers do you get for normal disks?


Thanks!

--
Al

