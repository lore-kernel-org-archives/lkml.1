Return-Path: <linux-kernel-owner+w=401wt.eu-S933962AbZJGR1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933962AbZJGR1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759702AbZJGR1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:27:05 -0400
Received: from brick.kernel.dk ([93.163.65.50]:34980 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759628AbZJGR1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:27:03 -0400
Date: Wed, 7 Oct 2009 19:26:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, drbd-dev@lists.linbit.com,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] drbd: needs __ratelimit()
Message-ID: <20091007172626.GG8703@kernel.dk>
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au> <20091007102153.1a19119b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007102153.1a19119b.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> drbd_int.h uses __ratelimit(), so it needs to #include ratelimit.h:
> 
> drivers/block/drbd/drbd_int.h:1765: error: implicit declaration of function '__ratelimit'

Thanks Randy, applied.

-- 
Jens Axboe

