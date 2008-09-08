Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYIHJbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYIHJbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYIHJbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:31:03 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37699 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752008AbYIHJbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:31:01 -0400
Date: Mon, 8 Sep 2008 11:30:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc5-mm1: list corruption during blk_add_timer()
Message-ID: <20080908093058.GI20055@kernel.dk>
References: <20080904224004.d3dd3076.akpm@linux-foundation.org> <20080905172602.GC11569@x200.localdomain> <20080905124039.2c9ebf20.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080905124039.2c9ebf20.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05 2008, Andrew Morton wrote:
> On Fri, 5 Sep 2008 21:26:02 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > Jens, send to Andrew whatever you fixed in git://git.kernel.dk/linux-2.6-block.git for-2.6.28
> 
> I went looking, but afaict the whole thing got removed from today's
> linux-next.  block/blk-timeout.c isn't there any more.

It's back in there since friday, hopefully this time more solid :-)

> 
> > 
> > [   24.567512] ------------[ cut here ]------------
> > [   24.567619] WARNING: at lib/list_debug.c:30 __list_add+0x95/0xa0()
> > [   24.567722] list_add corruption. prev->next should be next (ffff88017f9b8420), but was ffff88017f9b8588. (prev=ffff88017f9b8858).
> 
> 

-- 
Jens Axboe

