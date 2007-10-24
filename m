Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbXJXLDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbXJXLDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXJXLD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:03:27 -0400
Received: from brick.kernel.dk ([87.55.233.238]:23201 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbXJXLD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:03:26 -0400
Date: Wed, 24 Oct 2007 13:03:23 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, jdike@karaya.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Git Patch] arch/um/drivers/ubd_kern.c: fix a building error
Message-ID: <20071024110323.GO14671@kernel.dk>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024081047.GC2464@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024081047.GC2464@hacking>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, WANG Cong wrote:
> 
> Fix this uml building error:
> arch/um/drivers/ubd_kern.c: In function 'do_ubd_request':
> arch/um/drivers/ubd_kern.c:1118: error: implicit declaration of function 'sg_page'
> arch/um/drivers/ubd_kern.c:1118: warning: passing argument 6 of 'prepare_request' makes pointer from integer without a cast
> make[1]: *** [arch/um/drivers/ubd_kern.o] Error 1
> make: *** [arch/um/drivers] Error 2
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks, applied!

-- 
Jens Axboe

