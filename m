Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYHBRmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYHBRmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbYHBRm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:42:28 -0400
Received: from 1wt.eu ([62.212.114.60]:2363 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbYHBRm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:42:28 -0400
Date: Sat, 2 Aug 2008 19:42:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: oliver.pntr@gmail.com
Cc: stable@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC, 2.6.26.2-rc1] NFS: Ensure we call nfs_sb_deactive() after releasing the directory inode
Message-ID: <20080802174220.GF615@1wt.eu>
References: <ec5c3df63eafa2691665b95e989d7c3c@zipernowsky.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec5c3df63eafa2691665b95e989d7c3c@zipernowsky.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

most of your mails are line-wrapped at some locations :

> diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
> index 3adf8b2..f089e58 100644
> --- a/fs/nfs/unlink.c
> +++ b/fs/nfs/unlink.c
> @@ -95,10 +95,11 @@ static void nfs_async_unlink_done(struct rpc_task
> *task, void *calldata)
^^^^^^^^
see here.

You may have to fix your mailer (or use another one).

Regards,
Willy

