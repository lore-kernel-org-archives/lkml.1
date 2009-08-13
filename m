Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZHMIU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZHMIU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 04:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878AbZHMIU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 04:20:57 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56469 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732AbZHMIU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 04:20:57 -0400
Date: Thu, 13 Aug 2009 10:20:58 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, heiko.carstens@de.ibm.com
Cc: David Miller <davem@davemloft.net>
Subject: inlined spinlocks on sparc64
Message-ID: <20090813082058.GX12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I deleted the original thread, so I can't reply there. Just a heads up
on the spinlock inlining on sparc64. I decided to give your patches a
shot, since one of my IO benchmarks here basically degenerates into a
spinlock microbenchmark with > 50% time spent there (unlock part,
according to perf). Some of that is surely caching effects, but still.

For this particular workload, I get a net improvement of about 3.5% with
the inlined functions. Not bad.

-- 
Jens Axboe

