Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbXJ3JnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbXJ3JnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbXJ3JnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:43:12 -0400
Received: from brick.kernel.dk ([87.55.233.238]:1821 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbXJ3JnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:43:11 -0400
Date: Tue, 30 Oct 2007 10:40:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: [PATCH 0/3] Deadline iosched: Fix batching algorithm
Message-ID: <20071030094040.GK4993@kernel.dk>
References: <4726AD03.2080908@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4726AD03.2080908@gelato.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30 2007, Aaron Carroll wrote:
> Hi Jens,
> 
> The following patches correct some issues with the deadline I/O
> scheduler and its batching algorithm.
> 
> Patch 1 is a simple function factorisation.
> Patch 2 fixes a missing batch count reset, making the behaviour
>   closer to that implied by the documentation.

1+2 are no brainers, applied.

> Patch 3 changes batch start points to resolve a disparity in
>   latency and bandwidth between high- and low-sector requests.

This one makes a lot of sense, applied as well.

Thanks!

-- 
Jens Axboe

