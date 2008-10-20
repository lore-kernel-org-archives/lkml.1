Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYJTRuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYJTRuz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 13:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYJTRuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 13:50:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:34143 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbYJTRup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 13:50:45 -0400
Date: Mon, 20 Oct 2008 19:49:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add block device speciffic splice write method
Message-ID: <20081020174931.GH19428@kernel.dk>
References: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224424858-3927-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19 2008, Dmitri Monakhov wrote:
> Block device write procedure is different from regular file:
>  - Actual write performed without i_mutex.
>  - It has no metadata, so generic_osync_inode(O_SYNCMETEDATA) can not livelock.
>  - We do not have to worry about S_ISUID/S_ISGID bits.

I already did an O_DIRECT part of block device splicing [1], I'll fold
this into the splice branch and double check with some testing.

[1] http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=fbb724a0484aba938024d41ca1dd86337d2550c9;hp=08c7910b275a4c580ad646ae8654439c8dfae4c5

-- 
Jens Axboe

