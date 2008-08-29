Return-Path: <linux-kernel-owner+w=401wt.eu-S1756582AbYH2K5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbYH2K5R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbYH2K5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:57:05 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52511 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYH2K5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:57:05 -0400
Date: Fri, 29 Aug 2008 12:57:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Subject: Re: v2.6.27-rc5 regression: mtd/block device issue with cmd_filter
Message-ID: <20080829105700.GT20055@kernel.dk>
References: <200808291250.36591.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808291250.36591.laurentp@cse-semaphore.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29 2008, Laurent Pinchart wrote:
> Hi everybody,
> 
> the following commit either introduces a regression or makes and MTD-related issue come up to the surface:
> 
> abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 introduces 
> block: move cmdfilter from gendisk to request_queue
> 
> When registering an MTD device that contains several partitions, the kernel complains about reinitialization of a kobject:

Already known and fixed, see patch here:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=bb23b431db7405f6d79f989ad0236bf6428ba1cb

Will go upstream later today.

-- 
Jens Axboe

