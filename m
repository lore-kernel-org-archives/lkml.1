Return-Path: <linux-kernel-owner+w=401wt.eu-S1756147AbZELP1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147AbZELP1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZELP1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:27:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:56097 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbZELP1o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:27:44 -0400
Message-ID: <4A099562.7020805@kernel.org>
Date: Wed, 13 May 2009 00:27:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of blk_update_request
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A098B8D.10107@panasas.com>
In-Reply-To: <4A098B8D.10107@panasas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 12 May 2009 15:27:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Boaz Harrosh wrote:
> blk_update_request() was meant for request-based-multi-path, and not for swim3
> please see:
>     32fab448 block: add request update interface
> 
> CC: Kiyoshi Ueda<k-ueda@ct.jp.nec.com>
> 
> I think Tejun Heo was just using that in some recent block layer,
> transformation.
> Tejun?

Yeah, conversion was easy that way.  I think it's sane to have
blk_update_request() exported as long as request internal tinkering is
kept in block layer proper.

Thanks.

-- 
tejun
