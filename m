Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYIWDPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYIWDPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 23:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754407AbYIWDPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 23:15:34 -0400
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:38639 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753239AbYIWDPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 23:15:33 -0400
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
To: Martin Steigerwald <ms@teamix.de>
Date: Tue, 23 Sep 2008 13:15:21 +1000
Message-ID: <48D85F49.4080001@gelato.unsw.edu.au>
User-Agent: Thunderbird 2.0.0.14 (X11/20080618)
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Documentation on CFQ iosched parameters
References: <200809221715.33143.ms@teamix.de>
In-Reply-To: <200809221715.33143.ms@teamix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Steigerwald wrote:
> Hi!
> 
> I am searching documentation about CFQ io scheduler. I can't find it in linux 
> 2.6.26 Documentation directory.
> 
> I found about these in german[1]:
> 
> back_seek_max:16384
> back_seek_penalty:2
> fifo_expire_async:250
> fifo_expire_sync:123
> quantum:4
> 
> But I am completely missing about these:
> 
> slice_async:40

Base length of an asynchronous queue timeslice (that is, how long the
queue has to dispatch requests each round).  The actual timeslice
length is scaled by the I/O priority.

> slice_async_rq:2

The base number of requests per round for asynchronous queues.  Like
slice_async, the actual maximum is a function of slice_async_rq and I/O
priority.

> slice_idle:6

How long to wait for processes to produce more I/O before switching
queues. This is for anticipation of sequential I/O, and more even disk
time distribution for processes doing back to back synchronous I/Os.

> slice_sync:100

Same as slice_async, but for synchronous requests.

