Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXKTDmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXKTDmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754045AbXKTDmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:42:10 -0500
Received: from mx1.suse.de ([195.135.220.2]:34253 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbXKTDmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:42:09 -0500
Date: Tue, 20 Nov 2007 04:42:06 +0100
From: Nick Piggin <npiggin@suse.de>
To: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] radix_tree.h trivial comment correction
Message-ID: <20071120034205.GA27474@wotan.suse.de>
References: <20071119191747.GA17234@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071119191747.GA17234@tpepper-t42p.dolavim.us>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 11:17:48AM -0800, Tim Pepper wrote:
> There is an unmatched parenthesis in the locking commentary of radix_tree.h
> which is trivially fixed by the patch below.
> 
> Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
> Cc: Nick Piggin <npiggin@suse.de>

Acked-by: Nick Piggin <npiggin@suse.de>

> 
> ---
> 
> diff --git a/include/linux/radix-tree.h b/include/linux/radix-tree.h
> --- a/include/linux/radix-tree.h
> +++ b/include/linux/radix-tree.h
> @@ -91,7 +91,7 @@ do {									\
>   *
>   * For API usage, in general,
>   * - any function _modifying_ the tree or tags (inserting or deleting
> - *   items, setting or clearing tags must exclude other modifications, and
> + *   items, setting or clearing tags) must exclude other modifications, and
>   *   exclude any functions reading the tree.
>   * - any function _reading_ the tree or tags (looking up items or tags,
>   *   gang lookups) must exclude modifications to the tree, but may occur
