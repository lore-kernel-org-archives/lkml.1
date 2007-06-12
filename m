Return-Path: <linux-kernel-owner+w=401wt.eu-S1758324AbXFLGml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758324AbXFLGml (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 02:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752883AbXFLGme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 02:42:34 -0400
Received: from brick.kernel.dk ([80.160.20.94]:17368 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755AbXFLGme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 02:42:34 -0400
Date: Tue, 12 Jun 2007 08:40:18 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] readahead update on splice reads
Message-ID: <20070612064018.GP18832@kernel.dk>
References: <20070612030450.590659600@mail.ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070612030450.590659600@mail.ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12 2007, Fengguang Wu wrote:
> Andrew,
> 
> The two patches optimizes readahead invocations in splice reads:
> 
> 	readahead: move synchronous readahead call out of splice loop
> 	readahead: pass real splice size
> 
> They can be appended to readahead-convert-splice-invocations.patch in
> -mm tree.

Patches look nice, but unfortunately only -mm stuff and will need to be
rebased once 2.6.23 opens anyway.

Where are we on the ondemand read-ahead merging? -mm has continually had
different read-ahead code than mainline now for seemingly years, seems a
bit pointless to me. Either we get the stuff merged, or toss it out.
Nothing needs to simmer that long.

I suspect we wont see any real potential regressions before it hits
mainline anyway.

-- 
Jens Axboe

