Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYEVTYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYEVTYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754027AbYEVTY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:24:29 -0400
Received: from stinky.trash.net ([213.144.137.162]:44895 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbYEVTY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:24:28 -0400
Message-ID: <4835C806.6020408@trash.net>
Date: Thu, 22 May 2008 21:22:46 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Pekka J Enberg <penberg@cs.helsinki.fi>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com, clameter@sgi.com
Subject: Re: [PATCH] netfilter: use krealloc() in nf_conntrack_extend.c V2
References: <Pine.LNX.4.64.0805222145320.6071@sbz-30.cs.Helsinki.FI> <Pine.LNX.4.64.0805222155150.6294@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0805222155150.6294@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg wrote:
> To: kaber@trash.net
> [PATCH] netfilter: use krealloc() in nf_conntrack_extend.c V2
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> The ksize() API is going away because it is being abused and it doesn't even
> work consistenly across different allocators. Therefore, convert
> net/netfilter/nf_conntrack_extend.c to use krealloc().
>
> Cc: <netfilter-devel@vger.kernel.org>
> Cc: <netdev@vger.kernel.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> Patrick, please use this patch instead. The previous one did the moving
> unconditionally which is wrong. This one moves entries around only if
> krealloc() allocated a new buffer.

Applied, thanks.
