Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbXGTLIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbXGTLIF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbXGTLHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:07:55 -0400
Received: from brick.kernel.dk ([80.160.20.94]:26142 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbXGTLHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:07:54 -0400
Date: Fri, 20 Jul 2007 13:07:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] remove the limit max_sectors_kb imposed on
	max_readahead_kb
Message-ID: <20070720110743.GT11657@kernel.dk>
References: <20070720100740.106917381@mail.ustc.edu.cn> <20070720101124.350754890@mail.ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070720101124.350754890@mail.ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20 2007, Fengguang Wu wrote:
> Remove the size limit max_sectors_kb imposed on max_readahead_kb.
> 
> max_sectors_kb cannot grow larger than max_hw_sectors_kb, which can be
> rather small for some disk drives.

Please CC me on core block layer changes, thanks.

The patch looks fine though! Your reasoning is a bit odd, though. I
think the depency between the two is just wrong and ugly, so I agree it
should go.

Acked-by: Jens Axboe <jens.axboe@oracle.com>

-- 
Jens Axboe

