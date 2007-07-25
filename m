Return-Path: <linux-kernel-owner+w=401wt.eu-S1764169AbXGYH0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764169AbXGYH0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 03:26:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762999AbXGYHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 03:25:57 -0400
Received: from brick.kernel.dk ([80.160.20.94]:9907 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762923AbXGYHZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 03:25:56 -0400
Date: Wed, 25 Jul 2007 09:26:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsg: Fix build for CONFIG_BLOCK=n
Message-ID: <20070725072624.GG3287@kernel.dk>
References: <20070725072354.GA18706@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725072354.GA18706@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25 2007, Paul Mundt wrote:
> BLK_DEV_BSG was added outside of the if BLOCK check, which allows it to
> be enabled when CONFIG_BLOCK=n. This leads to many screenlengths of
> errors, starting with a parse error on the request_queue_t definition.
> Obviously this wasn't intended for CONFIG_BLOCK=n usage, so just move the
> option back in to the block.
> 
> Caught with a randconfig on sh.
> 
> Signed-off-by: Paul Mundt <lethal@linux-sh.org>

That's definitely correct.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

