Return-Path: <linux-kernel-owner+w=401wt.eu-S1760705AbXGPGf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760705AbXGPGf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 02:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752929AbXGPGfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 02:35:19 -0400
Received: from brick.kernel.dk ([80.160.20.94]:28127 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbXGPGfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 02:35:18 -0400
Date: Mon, 16 Jul 2007 08:34:36 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix wrong __splice_from_pipe() usage
Message-ID: <20070716063435.GG5328@kernel.dk>
References: <877ip1qj29.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877ip1qj29.fsf@duaron.myhome.or.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16 2007, OGAWA Hirofumi wrote:
> Hi,
> 
> I've noticed the nfsd read corruption by recent change. And this patch
> fixes the problem for me, is this right fix?
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> 
> 
> __splice_from_pipe() is updating the sd->pos for the actor, but those
> functions are passing the sd of reader side directory. So, splice
> updates sd->pos twice.
> 
> This fixes usage of __splice_from_pipe().

For sendfile() usage, or the nfsd path that uses splice to send?

-- 
Jens Axboe

