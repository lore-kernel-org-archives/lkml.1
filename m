Return-Path: <linux-kernel-owner+w=401wt.eu-S1756037AbXD0Pzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756037AbXD0Pzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:55:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXD0Pzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:55:38 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037AbXD0PzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:55:20 -0400
Date: Fri, 27 Apr 2007 08:54:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
In-Reply-To: <alpine.DEB.0.98.0704271139190.29118@sigma.j-a-k-j.com>
Message-ID: <alpine.LFD.0.98.0704270852480.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
 <alpine.DEB.0.98.0704271139190.29118@sigma.j-a-k-j.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 27 Apr 2007, John Anthony Kazos Jr. wrote:
> 
> Could[/should] this stuff be changed from ratios to amounts? Or a quick 
> boot-time test to use a ratio if the memory is small and an amount (like 
> tax brackets, I would expect) if it's great?

Yes, the "percentage" thing was likely wrong. That said, there *is* some 
correlation between "lots of memory" and "high-end machine", and that in 
turn tends to correlate with "fast disk", so I don't think the percentage 
approach is really *horribly* wrong.

The main issue with the percentage is that we do export them as such 
through the /proc/ interface, and they are easy to change and understand. 
So changing them to amounts is non-trivial if you also want to support the 
old interfaces - and the advantage isn't obvious enough that it's a 
clear-cut case.

		Linus
