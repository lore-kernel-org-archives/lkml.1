Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZJAROT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZJAROT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 13:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZJAROS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 13:14:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752708AbZJAROR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 13:14:17 -0400
Date: Thu, 1 Oct 2009 10:12:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Tejun Heo <tj@kernel.org>
cc: jeff@garzik.org, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com
Subject: Re: [PATCH 19/19] workqueue: implement concurrency managed
 workqueue
In-Reply-To: <1254384558-1018-20-git-send-email-tj@kernel.org>
Message-ID: <alpine.LFD.2.01.0910011008210.6996@localhost.localdomain>
References: <1254384558-1018-1-git-send-email-tj@kernel.org> <1254384558-1018-20-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Oct 2009, Tejun Heo wrote:
>
> To solve the above issues, this patch implements concurrency-managed
> workqueue.

Ok, all the other patches in the series looked great, this one looks 
scary. Everything else was pretty small and targeted, and if bugs appear, 
bisection would show the step that was nasty.

And then comes the big flag-day patch that actually introduces all the new 
logic, and is the most complex of the lot.

Maybe it's inevitable, but if this one could be split up a bit more, I'd 
find the series less scary.

I don't know how, though (except by adding code that simply isn't used in 
previous patches, and that doesn't really help anything at all), so maybe 
the big "switch everything over at once" thing is unavoidable.

		Linus
