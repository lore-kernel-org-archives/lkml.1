Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYJAHtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYJAHtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 03:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYJAHtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 03:49:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:50971 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbYJAHtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 03:49:01 -0400
Date: Wed, 1 Oct 2008 09:48:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Block: Fix blk_start_queueing() so as not to process a stopped queue
Message-ID: <20081001074843.GA19428@kernel.dk>
References: <87wsgtb4t6.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wsgtb4t6.fsf@denkblock.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01 2008, Elias Oltmanns wrote:
> Especially since blk_start_queueing() is used as the unplug_fn() callback
> by the cfq scheduler, we'd better make it behave like a proper unplug
> function. That is to say, return immediately if the queue is stopped.
> 
> Cc: stable <stable@kernel.org>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> ---
> This is not a recent regression, so it might not be accepted as an rc
> fix. However, it most definitely is a bug and should go into a stable
> release. Applies to 2.6.27-rc8.

I don't think this is by far serious enough for -stable. Please let me
know what bad behaviour you observed due to this bug?

-- 
Jens Axboe

