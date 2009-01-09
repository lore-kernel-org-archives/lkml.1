Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbZAIIGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbZAIIGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 03:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZAIIG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 03:06:28 -0500
Received: from brick.kernel.dk ([93.163.65.50]:1900 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbZAIIG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 03:06:27 -0500
Date: Fri, 9 Jan 2009 09:05:17 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: ???? ?? <mauriceliu27@hotmail.com>
Cc: linux-kernel@vger.kernel.org, nick piggin <nickpiggin@yahoo.com.au>,
       drzeus@drzeus.cx
Subject: Re: [BUG] AS-ioscheduler: kernel panic at as_exit_queue
Message-ID: <20090109080517.GI32491@kernel.dk>
References: <COL120-W718F2E0FBF40D8870415BFDEDC0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <COL120-W718F2E0FBF40D8870415BFDEDC0@phx.gbl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08 2009, ???? ?? wrote:
> 
> Hi Nick & Jens,
> 
>  I met a Kernel Panic with AS, the panic pc is at as_exit_queue, and panic
>  when the function check whether the fifo_list[REQ_SYNC] and
>  fifo_list[REQ_ASYNC] are empty or not, it would Panic if the lists are not
> empty.
> 
>       The k-panic happened when I plugged out my Micro-SD memory card
>  from my phone, the log has been attached onto this mail.
> 
>       I guess there may be some conflicts between AS and Hot-plug
>  mechanism, so I read the code of AS code by code to find anything
>  suspicious. I find that AS might does not consider that do any operations
>  to the fifo_lists when the device driver try to exit its elevator, so there
>  is possibility that when device try to exit, the fifo_lists are not empty,
>  and happen kernel panic, though the possibility is really really very
>  small:).
> 
>       Unfortunately, I have met such k-panic more than two times, so I
>  think I should get your suggestions first, and then try to do some works
>  for this problem:) Look forward for your reply:)
> 
> My Linux version :  2.6.25

Please try a newer version, I _think_ this was fixed in sd. CC'ing
Pierre, just in case.

-- 
Jens Axboe

