Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbZIRSkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbZIRSkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 14:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757490AbZIRSkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 14:40:19 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50455 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757453AbZIRSkT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 14:40:19 -0400
Subject: Re: [PATCH] nfs: fix bdi_unregister() before sb kill
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, a.p.zijlstra@chello.nl
In-Reply-To: <20090918183203.GG23126@kernel.dk>
References: <20090917124233.GJ23126@kernel.dk>
	 <20090917194027.GS23126@kernel.dk>
	 <1253229410.2783.16.camel@heimdal.trondhjem.org>
	 <20090918064006.GU23126@kernel.dk> <20090918150248.GB23126@kernel.dk>
	 <1253290790.3183.14.camel@heimdal.trondhjem.org>
	 <20090918173608.GD23126@kernel.dk>  <20090918183203.GG23126@kernel.dk>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 14:40:18 -0400
Message-Id: <1253299218.3183.84.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 3 msgs/h 1 sum rcpts/h 4 sum msgs/h 1 total rcpts 1482 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 61C92D07A7AE0E4C11F8A29197155D4C53155918
X-UiO-SPAM-Test: remote_host: 198.95.226.230 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 25 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 20:32 +0200, Jens Axboe wrote:
> How does this look? It compiles, but I cannot test before sunday. It
> would be great if you (or someone else) could :-). Peter, if you have
> the time, it would be nice if you could check whether this one works for
> you too.
> 
> diffstat is tasty, too:
> 
>  client.c |    4 ----
>  super.c  |   53 ++++++++++++++++++++++++++---------------------------
>  2 files changed, 26 insertions(+), 31 deletions(-)

Yep! The patch looks good to me. I'll see if I can find the time to test
it tomorrow.

Cheers
  Trond

