Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab0CAJt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:49:56 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48189 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0CAJtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:49:53 -0500
Date: Mon, 1 Mar 2010 10:49:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cfq: remove 8 bytes of padding from cfq_rb_root on 64
	bit  builds
Message-ID: <20100301094952.GU5768@kernel.dk>
References: <1267436765.2127.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267436765.2127.10.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01 2010, Richard Kennedy wrote:
> Reorder cfq_rb_root to remove 8 bytes of padding on 64 bit builds.
>     
> 
> Consequently removing 56 bytes from cfq_group and 64 bytes from
> cfq_data.

Thanks Richard, applied.

-- 
Jens Axboe

