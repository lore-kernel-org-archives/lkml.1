Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZAaIr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZAaIr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 03:47:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZAaIru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 03:47:50 -0500
Received: from brick.kernel.dk ([93.163.65.50]:27208 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZAaIrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 03:47:49 -0500
Date: Sat, 31 Jan 2009 09:45:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Lorenzo Allegrucci <l.allegrucci@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: SSD and IO schedulers
Message-ID: <20090131084558.GV30821@kernel.dk>
References: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dcf7d360901301355l7ed26a5aob7ef6d79d9607b6b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30 2009, Lorenzo Allegrucci wrote:
> Hi, I was wondering how IO schedulers such as as-iosched, deadline and
> cfq behave on SSD
> (that have virtually no seek time), from a theoretical point of view.
> How do they affect
> performance on these devices?
> I heard that the noop scheduler is often chosen by owners of EeePcs
> (with a SSD unit).
> They report superior performance by using this (quite simple) scheduler.
> Are there any scientific benchmarks around?

Just recently the io schedulers started checking for SSD devices, so
today it should not matter performance wise (throughput) whether you use
CFQ or NOOP on eg the eeepc. The io scheduler is still quite important
for providing fair access to the device, especially on the cheaper end
of the SSD segment.

-- 
Jens Axboe

