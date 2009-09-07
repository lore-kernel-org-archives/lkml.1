Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZIGL5u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZIGL5u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 07:57:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZIGL5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 07:57:49 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44948 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZIGL5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 07:57:48 -0400
Date: Mon, 7 Sep 2009 13:57:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907115750.GW18599@kernel.dk>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907094953.GP18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 07 2009, Jens Axboe wrote:
> Scheduler       Runtime         Max lat     Avg lat     Std dev
> ----------------------------------------------------------------
> CFS             100             951         462         267
> CFS-x2          100             983         484         308
> BFS
> BFS-x2

Those numbers are buggy, btw, it's not nearly as bad. But responsiveness
under compile load IS bad though, the test app just didn't quantify it
correctly. I'll see if I can get it working properly.

-- 
Jens Axboe

