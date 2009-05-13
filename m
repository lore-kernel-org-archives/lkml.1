Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZEMFtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZEMFtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 01:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZEMFtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 01:49:03 -0400
Received: from brick.kernel.dk ([93.163.65.50]:43015 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787AbZEMFtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 01:49:00 -0400
Date: Wed, 13 May 2009 07:49:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>, Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org
Subject: Re: [PATCH] swim3: use blk_end_request instead of
	blk_update_request
Message-ID: <20090513054901.GW4140@kernel.dk>
References: <1242127787-29842-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1242127787-29842-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4A098B8D.10107@panasas.com> <4A099562.7020805@kernel.org> <4A0A1941.2010105@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A0A1941.2010105@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13 2009, Kiyoshi Ueda wrote:
> Hi,
> 
> Thank you for pointing this, Boaz!
> 
> On 2009/05/13 0:27 +0900, Tejun Heo wrote:
> > Hello,
> > 
> > Boaz Harrosh wrote:
> >> blk_update_request() was meant for request-based-multi-path, and not for swim3
> >> please see:
> >>     32fab448 block: add request update interface
> >>
> >> CC: Kiyoshi Ueda<k-ueda@ct.jp.nec.com>
> >>
> >> I think Tejun Heo was just using that in some recent block layer,
> >> transformation.
> >> Tejun?
> > 
> > Yeah, conversion was easy that way.  I think it's sane to have
> > blk_update_request() exported as long as request internal tinkering is
> > kept in block layer proper.
> 
> blk_update_request() is needed for request-based dm to keep the request
> completion ordering in bottom-up, although request-based dm is not
> in upstream yet.
> 
> Jens, please keep blk_update_request() exported.

I did, I applied the swim3 patches yesterday as well.

-- 
Jens Axboe

