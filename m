Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbYBJXjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbYBJXjV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 18:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYBJXjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 18:39:09 -0500
Received: from 1wt.eu ([62.212.114.60]:1833 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbYBJXjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 18:39:08 -0500
Date: Mon, 11 Feb 2008 00:37:04 +0100
From: Willy Tarreau <w@1wt.eu>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jens.axboe@oracle.com, akpm@linux-foundation.org,
       bastian@waldi.eu.org, ndenev@gmail.com, oliver.pntr@gmail.com
Subject: Re: [PATCH] splice: fix user pointer access in get_iovec_page_array()
Message-ID: <20080210233703.GR8953@1wt.eu>
References: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802101644510.12440@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 04:47:57PM +0200, Pekka J Enberg wrote:
> From: Bastian Blank <bastian@waldi.eu.org>
> 
> The commit 8811930dc74a503415b35c4a79d14fb0b408a361 ("splice: missing user
> pointer access verification") added access_ok() to copy_from_user_mmap_sem()
> which only ensures we can copy the struct iovecs from userspace to the kernel
> but we also must check whether we can access the actual memory region pointed
> to by the struct iovec to close the local root exploit.
> 
> Cc: <stable@kernel.org>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> Bastian, can I have your Signed-off-by for this, please? Oliver, Niki, can 
> you please confirm this closes the hole?

Pekka, I confirm that it also closes the hole once backported to 2.6.22.

Willy

