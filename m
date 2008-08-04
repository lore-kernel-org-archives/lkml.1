Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYHDJ7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYHDJ7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYHDJ7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:59:04 -0400
Received: from brick.kernel.dk ([87.55.233.238]:26084 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYHDJ7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:59:04 -0400
Date: Mon, 4 Aug 2008 11:59:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Miller <mike.miller@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove pointless curr_queue calculation in block/cciss.c
Message-ID: <20080804095900.GC20055@kernel.dk>
References: <488598C9.6000701@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488598C9.6000701@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22 2008, Hannes Reinecke wrote:
> Hi Mike,
> 
> in block/cciss.c:cciss_check_queues() curr_queue is calculated
> as the last statement in a for loop, although it's being initialized
> with the next round again and never been used afterwards.
> So this can be removed.

Indeed, pretty silly. Applied, thanks.

-- 
Jens Axboe

