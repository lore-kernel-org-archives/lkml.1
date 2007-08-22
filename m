Return-Path: <linux-kernel-owner+w=401wt.eu-S932793AbXHVU0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793AbXHVU0t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763358AbXHVU0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:26:42 -0400
Received: from mail.fieldses.org ([66.93.2.214]:34512 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763204AbXHVU0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:26:41 -0400
Date: Wed, 22 Aug 2007 16:26:39 -0400
To: "Morrison, Tom" <tmorrison@empirix.com>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Rushton, Matt" <Mrushton@empirix.com>
Subject: Re: NFS/RPC Hangs after updating time...
Message-ID: <20070822202639.GL20946@fieldses.org>
References: <BD261180E6D35F4D9D32F3E44FD3D90108F975FB@EMPBEDEX.empirix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD261180E6D35F4D9D32F3E44FD3D90108F975FB@EMPBEDEX.empirix.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 02:37:22PM -0400, Morrison, Tom wrote:
> I am working with a 2.6.11++ kernel on an embedded 
> server platform that is NFS serving Linux rootfs 
> for other embedded NFS Client boards.
> 
> Everything works fine when the system time on the 
> server board is relatively synchronized with the real-time. 
> 
> It hangs after attempting to update the time from a 
> nonsensical time (e.g.: 2 months ago) - the most significant
> part of it is that it only hangs IFF it has started 
> serving its NFS client boards before I attempt to 
> update the time.
> 
> 
> The most significant output (when turning on 
> RPC debugging) is from:
> 
>   linux/net/sunrpc/cache.c (cache_check) - line 90:
> 
>          >> Want update, refage=1800, age=4288285
> 
> It continually loops through this method - and the cache
> never gets updated...even thought with some additional
> sleuthing (aka: additional debug printks - it thinks 
> that there is an cache update pending).

Can you reproduce the problem with the current kernel? (Say 2.6.22 or
later?)

--b.
