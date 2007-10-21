Return-Path: <linux-kernel-owner+w=401wt.eu-S1753636AbXJUTRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636AbXJUTRH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 15:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751905AbXJUTQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 15:16:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11307 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbXJUTQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:16:53 -0400
Date: Sun, 21 Oct 2007 21:16:48 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick <gentuu@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] blk_sync_queue() should cancel request_queue->unplug_work
Message-ID: <20071021191648.GV10674@kernel.dk>
References: <20071020122021.GA2490@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071020122021.GA2490@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20 2007, Oleg Nesterov wrote:
> (untested, needs an explicit ack/nack from maintainer)
> 
> blk_sync_queue() cancels the timer, but forgets to cancel the work.

Applied 1-2, thanks a lot Oleg.

-- 
Jens Axboe

