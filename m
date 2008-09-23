Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYIWJAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYIWJAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbYIWJAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:00:33 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52520 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbYIWJAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:00:32 -0400
Date: Tue, 23 Sep 2008 11:00:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Cc: Martin Steigerwald <ms@teamix.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Documentation on CFQ iosched parameters
Message-ID: <20080923090029.GV26460@kernel.dk>
References: <200809221715.33143.ms@teamix.de> <48D85F49.4080001@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D85F49.4080001@gelato.unsw.edu.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23 2008, Aaron Carroll wrote:
> Martin Steigerwald wrote:
> >Hi!
> >
> >I am searching documentation about CFQ io scheduler. I can't find it in 
> >linux 2.6.26 Documentation directory.
> >
> >I found about these in german[1]:
> >
> >back_seek_max:16384
> >back_seek_penalty:2
> >fifo_expire_async:250
> >fifo_expire_sync:123
> >quantum:4
> >
> >But I am completely missing about these:
> >
> >slice_async:40
> 
> Base length of an asynchronous queue timeslice (that is, how long the
> queue has to dispatch requests each round).  The actual timeslice
> length is scaled by the I/O priority.
> 
> >slice_async_rq:2
> 
> The base number of requests per round for asynchronous queues.  Like
> slice_async, the actual maximum is a function of slice_async_rq and I/O
> priority.
> 
> >slice_idle:6
> 
> How long to wait for processes to produce more I/O before switching
> queues. This is for anticipation of sequential I/O, and more even disk
> time distribution for processes doing back to back synchronous I/Os.
> 
> >slice_sync:100
> 
> Same as slice_async, but for synchronous requests.

Nothing further to add, Aaron nailed them.

-- 
Jens Axboe

