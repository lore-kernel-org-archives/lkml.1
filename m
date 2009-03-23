Return-Path: <linux-kernel-owner+w=401wt.eu-S1759639AbZCWQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639AbZCWQEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbZCWQBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:01:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:57172 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759395AbZCWQBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:01:14 -0400
Date: Mon, 23 Mar 2009 08:58:42 -0700
From: Greg KH <gregkh@suse.de>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] DRBD: lru_cache
Message-ID: <20090323155842.GA7568@suse.de>
References: <1237823287-12734-1-git-send-email-philipp.reisner@linbit.com> <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237823287-12734-2-git-send-email-philipp.reisner@linbit.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 04:47:56PM +0100, Philipp Reisner wrote:
> The lru_cache is a fixed size cache of equal sized objects. It allows its
> users to do arbitrary transactions in case an element in the cache needs to
> be replaced. Its replacement policy is LRU.

You forgot to add a "Signed-off-by:" line to each patch :(

Also, a general description of what drbd is, and why we want it would be
good to have.

> ---
> diff -uNrp linux-2.6.29-rc8/drivers/block/drbd/lru_cache.h linux-2.6.29-rc8-drbd/drivers/block/drbd/lru_cache.h
> --- linux-2.6.29-rc8/drivers/block/drbd/lru_cache.h	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.29-rc8-drbd/drivers/block/drbd/lru_cache.h	2009-03-23 11:25:50.991276000 +0100
> @@ -0,0 +1,118 @@
> +/*
> +-*- linux-c -*-

I think you can delete these lines from all of your files.

thanks,

greg k-h
