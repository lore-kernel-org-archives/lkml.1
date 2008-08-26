Return-Path: <linux-kernel-owner+w=401wt.eu-S1758473AbYHZOjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473AbYHZOjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbYHZOjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:39:06 -0400
Received: from [93.163.65.50] ([93.163.65.50]:14098 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbYHZOjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:39:03 -0400
Date: Tue, 26 Aug 2008 16:39:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio_blk: use noop elevator by default
Message-ID: <20080826143900.GM20055@kernel.dk>
References: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1219754894.7235.44.camel@sebastian.kern.oss.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26 2008, Fernando Luis Vázquez Cao wrote:
> Hi Rusty,
> 
> Would it make sense to use noop by default? After all we do not know
> what is behind the backend driver and the hypervisor is likely to do its
> own scheduling anyway. I guess this is the reason the Xen guys took this
> approach.
> 
> What do you think about the patch below?

I plan to include some variant of disk profiling for 2.6.28 which will
let eg CFQ turn off idling for such device types, I think that is a
better solution.

-- 
Jens Axboe

