Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420AbZCBMZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbZCBMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 07:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCBMZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 07:25:50 -0500
Received: from brick.kernel.dk ([93.163.65.50]:59559 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbZCBMZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 07:25:50 -0500
Date: Mon, 2 Mar 2009 13:25:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: ???? <xiegang112@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: The difference of request dir between AS and Deadline I/O
	scheduler?
Message-ID: <20090302122547.GT11787@kernel.dk>
References: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d364733c0903012106g2625d433o4cdbbbcc5a9ff19a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 02 2009, ???? wrote:
> Hi,
> 
> I'm little confused about the defination of request dir in AS and
> Deadline I/O scheduler.
> In AS, the request dir is defined by wheher it's sync:
> 
> data_dir = rq_is_sync(rq);
> 
> But in Deadline, the requests are grouped by read and write.
> 
> Why is there the difference since AS is an extension of Deadline?
> what's the consideration?

Because AS uses the sync vs async distinction to decide whether to
anticipate a new request from that process. 'sync' is then reads or sync
writes, whereas deadline does not distinguish between sync and async
writes.

-- 
Jens Axboe

