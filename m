Return-Path: <linux-kernel-owner+w=401wt.eu-S1755992AbXD0PmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbXD0PmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbXD0PmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:42:06 -0400
Received: from seahorse.shentel.net ([204.111.1.244]:59557 "EHLO
	seahorse.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbXD0PmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:42:04 -0400
Date: Fri, 27 Apr 2007 11:41:06 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
Message-ID: <alpine.DEB.0.98.0704271139190.29118@sigma.j-a-k-j.com>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> One thing to try out (and dammit, I should make it the default now in 
> 2.6.21) is to just make the dirty limits much lower. We've been talking 
> about this for ages, I think this might be the right time to do it.

Could[/should] this stuff be changed from ratios to amounts? Or a quick 
boot-time test to use a ratio if the memory is small and an amount (like 
tax brackets, I would expect) if it's great?
