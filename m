Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYJIG71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYJIG71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754671AbYJIG7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:59:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56583 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbYJIG7P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:59:15 -0400
Date: Thu, 9 Oct 2008 08:58:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Denis ChengRq <crquan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Peter Osterlund <petero2@telia.com>,
       NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [VFS] mark bio_split_pool static
Message-ID: <20081009065832.GX19428@kernel.dk>
References: <1223038878-8038-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223038878-8038-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03 2008, Denis ChengRq wrote:
> Since all bio_split calls refer the same single bio_split_pool, the bio_split
> function can use bio_split_pool directly instead of the mempool_t parameter;
> 
> then the mempool_t parameter can be removed from bio_split param list, and
> bio_split_pool is only referred in fs/bio.c file, can be marked static.

Thanks, applied.

-- 
Jens Axboe

