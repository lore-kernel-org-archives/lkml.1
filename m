Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbXKZOo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbXKZOo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 09:44:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753756AbXKZOoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 09:44:22 -0500
Received: from brick.kernel.dk ([87.55.233.238]:25732 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbXKZOoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 09:44:21 -0500
Date: Mon, 26 Nov 2007 15:43:26 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: add more safeguards
Message-ID: <20071126144326.GC5050@kernel.dk>
References: <20071126112832.GA9232@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126112832.GA9232@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26 2007, Tejun Heo wrote:
> Add more safeguards to protect against misinterpreting a chain entry
> as a normal scatterlist and vice-versa.
> 
> * Make sure the entry isn't a chain when assigning and reading a
>   normal sg.
> 
> * Clear offset and length when chaining.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> While converting libata to use chained-sg, I felt a bit insecure and
> added a few more safe guards.  Feel free to include or ignore them.

Looks sane, thanks Tejun! Will apply it.

-- 
Jens Axboe

