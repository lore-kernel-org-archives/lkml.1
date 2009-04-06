Return-Path: <linux-kernel-owner+w=401wt.eu-S1757127AbZDFPrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757127AbZDFPrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZDFPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:47:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756076AbZDFPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:47:30 -0400
Date: Mon, 6 Apr 2009 08:45:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tytso@mit.edu
Subject: Re: [PATCH 0/8][RFC] IO latency/throughput fixes
In-Reply-To: <20090406151054.GD5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0904060840080.3863@localhost.localdomain>
References: <1239022088-29002-1-git-send-email-jens.axboe@oracle.com> <alpine.LFD.2.00.0904060803141.4023@localhost.localdomain> <20090406151054.GD5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 6 Apr 2009, Jens Axboe wrote:
>
> > Jens - I can just apply this queue (I want to test it out anyway), or if 
> > you prefer I can pull from you. Just tell me.
> 
> Whatever you want, if you want to pull instead of manually applying,
> it's:
> 
> git://git.kernel.dk/linux-2.6-block.git blk-latency

Ok, I applied them for testing anyway, so I think I'll just keep the 
series I have in my tree. I'm keeping my nasty "dd+sync" going in the 
background, just to verify that things really feel better, but I'm already 
convinced this is a winner. Especially with the request size limiter, I 
can really read email _almost_ as if nothing else was going on on the 
machine. 

With that request size limiting, my fsync pauses tend to be in the 250ms 
range, with a one 0.75s outlier in the last few minutes. I can definitely 
feel that quarter-second thing, and the .75s pause was a real stutter, but 
boy what a difference. I don't get the uncontrollable urge to kill that 
nasty background writer any more.

			Linus
