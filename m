Return-Path: <linux-kernel-owner+w=401wt.eu-S1764910AbXGZKwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764910AbXGZKwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 06:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756276AbXGZKwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 06:52:33 -0400
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:33072 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbXGZKwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 06:52:32 -0400
To: bzolnier@gmail.com
Cc: lethal@linux-sh.org, fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bsg: Fix build for CONFIG_BLOCK=n
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200707251304.56505.bzolnier@gmail.com>
References: <20070725072354.GA18706@linux-sh.org>
	<200707251304.56505.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070726195148F.fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 26 Jul 2007 19:51:48 +0900
X-Dispatcher: imput version 20040704(IM147)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] bsg: Fix build for CONFIG_BLOCK=n
Date: Wed, 25 Jul 2007 13:04:56 +0200

> 
> Hi,
> 
> On Wednesday 25 July 2007, Paul Mundt wrote:
> > BLK_DEV_BSG was added outside of the if BLOCK check, which allows it to
> > be enabled when CONFIG_BLOCK=n. This leads to many screenlengths of
> > errors, starting with a parse error on the request_queue_t definition.
> > Obviously this wasn't intended for CONFIG_BLOCK=n usage, so just move the
> > option back in to the block.
> > 
> > Caught with a randconfig on sh.
> 
> also pointed out in my bsg review from a week ago ;)
> 
> http://lkml.org/lkml/2007/7/17/487

Oops, sorry.


> > Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> Thanks for fixing this up.

Thanks!
