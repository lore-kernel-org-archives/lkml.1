Return-Path: <linux-kernel-owner+w=401wt.eu-S1753654AbXJWHa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbXJWHa1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbXJWHaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:30:10 -0400
Received: from brick.kernel.dk ([87.55.233.238]:12610 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbXJWHaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:30:09 -0400
Date: Tue, 23 Oct 2007 09:28:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-s390@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] net: fix xfrm build - missing scatterlist.h include
Message-ID: <20071023072843.GJ25962@kernel.dk>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com> <1193076664-13652-3-git-send-email-jens.axboe@oracle.com> <20071023051316.GB10055@osiris.boeblingen.de.ibm.com> <20071023051640.GL16425@kernel.dk> <20071023054441.GA24546@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023054441.GA24546@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> net/xfrm/xfrm_algo.c: In function 'skb_icv_walk':
> net/xfrm/xfrm_algo.c:555: error: implicit declaration of function 'sg_set_page'
> make[2]: *** [net/xfrm/xfrm_algo.o] Error 1

Thanks, arch fallout... Applied.

-- 
Jens Axboe

