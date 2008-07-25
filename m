Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYGYV2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYGYV2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYGYV20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:28:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56597 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYGYV2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:28:25 -0400
To: julia@diku.dk
CC: miklos@szeredi.hu, fuse-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-reply-to: <Pine.LNX.4.64.0807252131280.1602@ask.diku.dk> (message from
	Julia Lawall on Fri, 25 Jul 2008 21:33:25 +0200 (CEST))
Subject: Re: [PATCH] fs/suse/inode.c: Add missing fuse_request_alloc
References: <Pine.LNX.4.64.0807252131280.1602@ask.diku.dk>
Message-Id: <E1KMUpo-0007h4-P8@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jul 2008 23:28:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The error handling code for the second call to fuse_request_alloc should
> include freeing the result of the first one.

Thanks, queued for 2.6.27.

Miklos
