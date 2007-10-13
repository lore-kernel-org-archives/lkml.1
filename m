Return-Path: <linux-kernel-owner+w=401wt.eu-S1760861AbXJMKKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760861AbXJMKKk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 06:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbXJMKKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 06:10:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15865 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXJMKK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 06:10:29 -0400
Date: Sat, 13 Oct 2007 12:10:25 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
       Edward Shishkin <edward@namesys.com>, linux-kernel@vger.kernel.org,
       reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH] Reiser4: Drop 'size' argument from bio_endio and bi_end_io
Message-ID: <20071013101025.GE969@kernel.dk>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <470FDB41.2000102@free.fr> <20071012140023.30e5b30e.akpm@linux-foundation.org> <47109016.8000403@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47109016.8000403@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13 2007, Laurent Riffard wrote:
> Reiser4: Drop 'size' argument from bio_endio and bi_end_io
> 
> This patch pushes into Reiser4 the changes introduced by 
> commit 6712ecf8f648118c3363c142196418f89a510b90:
> 
> 	As bi_end_io is only called once when the request is complete,
> 	the 'size' argument is now redundant.  Remove it.
> 
> 	Now there is no need for bio_endio to subtract the size completed
> 	from bi_size.  So don't do that either.
> 
> 	While we are at it, change bi_end_io to return void.

Looks correct to me.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

