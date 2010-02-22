Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab0BVMty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 07:49:54 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36514 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349Ab0BVMtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 07:49:53 -0500
Date: Mon, 22 Feb 2010 13:49:51 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2]  cfq: reorder cfq_queue removing padding on 64bit &
	allowing more objects/slab in it's kmem_cache
Message-ID: <20100222124951.GR1025@kernel.dk>
References: <1266243036.2149.21.camel@localhost> <20100215141626.GB5355@redhat.com> <1266251188.7362.3.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266251188.7362.3.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15 2010, Richard Kennedy wrote:
> This removes 8 bytes of padding from struct cfq_queue on 64 bit builds,
> shrinking it's size to 256 bytes, so fitting into 1 fewer cachelines and
> allowing 1 more object/slab in it's kmem_cache.

Thanks, applied!

-- 
Jens Axboe

