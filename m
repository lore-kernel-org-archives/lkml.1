Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZFIC7y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZFIC7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 22:59:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFIC7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 22:59:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:39903 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbZFIC7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 22:59:44 -0400
Message-ID: <4A2DD019.6000503@kernel.org>
Date: Tue, 09 Jun 2009 11:59:37 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jens.axboe@oracle.com, giridhar.malavali@qlogic.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: needs to set the residual length of a bidi request.
References: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090609105709A.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 09 Jun 2009 02:59:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> This is against for-2.6.31.
> 
> This should fix the following problem:
> 
> http://marc.info/?l=linux-scsi&m=124449210813269&w=2
> 
> =
> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] block: needs to set the residual length of a bidi request
> 
> Tejun's "block: set rq->resid_len to blk_rq_bytes() on issue" patch
> seems to be incomplete; It doesn't set rq->resid_len to blk_rq_bytes()
> for a bidi request (req->next_rq). As a result, all bidi users are
> broken.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
