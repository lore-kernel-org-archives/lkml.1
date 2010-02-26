Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936028Ab0BZNBI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 08:01:08 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:52514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935891Ab0BZNBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 08:01:07 -0500
Date: Fri, 26 Feb 2010 14:01:05 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nikanth Karthikesan <knikanth@suse.de>, Jeff Moyer <jmoyer@redhat.com>,
       Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] io: remove padding from io_context on 64bit builds
Message-ID: <20100226130105.GV1025@kernel.dk>
References: <1267188960.2077.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267188960.2077.10.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 26 2010, Richard Kennedy wrote:
> On 64 bit builds when CONFIG_BLK_CGROUP=n (the default) this removes 8
> bytes of padding from structure io_context and drops its size from 72 to
> 64 bytes, so needing one fewer cachelines and allowing more objects per
> slab in it's kmem_cache.
> 
> Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

Thanks Richard, applied.

-- 
Jens Axboe

