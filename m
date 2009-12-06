Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbZLFIdz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbZLFIdz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:33:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbZLFIdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:33:50 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40927 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbZLFIdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:33:49 -0500
Message-ID: <4B1B6C6B.8080407@cs.helsinki.fi>
Date: Sun, 06 Dec 2009 10:33:47 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Tim Blechmann <tim@klingt.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] branch profiling on my nehalem machine showed 99% incorrect
 branch hints:
References: <84144f020911300944x89309c5r8e9079e1a62fb416@mail.gmail.com> <4B140806.9000308@klingt.org>
In-Reply-To: <4B140806.9000308@klingt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Blechmann wrote:
> i have regenerated the patch for tip/tip ...
> 
> --
>    28459  7678524  99 __cache_alloc_node             slab.c               3551
> 
> Discussion on lkml [1] led to the solution to remove this hint.
> 
> [1] http://patchwork.kernel.org/patch/63517/
> 
> Signed-off-by: Tim Blechmann <tim@klingt.org>
> ---
>  mm/slab.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

Please use plain text email for sending patches in the future.
