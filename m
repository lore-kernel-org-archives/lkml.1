Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbZELP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbZELP0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZELP0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:26:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:56054 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZELP0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:26:00 -0400
Message-ID: <4A0994FF.1030909@kernel.org>
Date: Wed, 13 May 2009 00:25:51 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH 0/2] swim3: use blk_end_request_all()
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 15:25:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

FUJITA Tomonori wrote:
> This is against for-2.6.31 branch in the block tree.
> 
> Tejun, don't we need to use blk_end_request_all() when we hit the
> maximum retry count in swim3_interrupt? Looks like we can't handle a
> request properly if we doesn't complete the request there.

Ummm.... why so?  Can you elaborate the bug scenario a bit?  I was
trying to keep the original behavior whereever possible.

> There are some other places to use blk_end_request_all if we need to.

There are some other places where end_request_all can be used but I
hope there isn't any place where we should but aren't.  :-)

Thanks.

-- 
tejun
