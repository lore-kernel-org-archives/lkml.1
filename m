Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYJJJHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYJJJHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbYJJJHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:07:31 -0400
Received: from nebensachen.de ([195.34.83.29]:43267 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347AbYJJJHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:07:31 -0400
X-Hashcash: 1:20:081010:jens.axboe@oracle.com::+kDbjIeVlF3XMKAW:00000000000000000000000000000000000000000/u2
X-Hashcash: 1:20:081010:linux-kernel@vger.kernel.org::r16Gg9w4IyLkt31y:0000000000000000000000000000000000xDH
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Block: Fix handling of stopped queues and a plugging issue
References: <87zllnound.fsf@denkblock.local>
Date: Fri, 10 Oct 2008 11:07:25 +0200
In-Reply-To: <87zllnound.fsf@denkblock.local> (Elias Oltmanns's message of
	"Thu, 02 Oct 2008 17:59:18 +0200")
Message-ID: <871vyoes36.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns <eo@nebensachen.de> wrote:
> Make sure that ->request_fn() really isn't called on queues that are
> supposed to be stopped. While at it, don't remove the plug in
> __blk_run_queue() unconditionally since this might lead to system hangs.
>
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> ---
> Applies to your devel tree.

Ping. Have you had a chance to look at this yet?

Regards,

Elias
