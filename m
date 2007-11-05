Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbXKEIBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbXKEIBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 03:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbXKEIBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 03:01:03 -0500
Received: from brick.kernel.dk ([87.55.233.238]:19632 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbXKEIBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 03:01:02 -0500
Date: Mon, 5 Nov 2007 08:57:33 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick <gentuu@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cfq: fix IOPRIO_CLASS_IDLE accounting
Message-ID: <20071105075732.GA5359@kernel.dk>
References: <20071104193221.GA12373@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071104193221.GA12373@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04 2007, Oleg Nesterov wrote:
> (untested, needs an ack from maintainer)
> 
> Spotted by Nick <gentuu@gmail.com>, hopefully can explain the second trace in
> http://bugzilla.kernel.org/show_bug.cgi?id=9180.
> 
> If ->async_idle_cfqq != NULL cfq_put_async_queues() puts it IOPRIO_BE_NR times
> in a loop. Fix this.

That's obviously buggy, thanks Oleg! Fix is indeed correct. I'll add it.

-- 
Jens Axboe

