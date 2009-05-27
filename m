Return-Path: <linux-kernel-owner+w=401wt.eu-S1763272AbZE0Mtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763272AbZE0Mtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 08:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762609AbZE0Mt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 08:49:26 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60389 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762890AbZE0Mt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 08:49:26 -0400
Date: Wed, 27 May 2009 14:49:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2.6-block/for-2.6.31] block: fix no diskstat problem
Message-ID: <20090527124927.GK11363@kernel.dk>
References: <4A1B50F8.1050401@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1B50F8.1050401@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26 2009, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> The commit below in 2.6-block/for-2.6.31 causes no diskstat problem
> because the blk_discard_rq() check was added with '&&'.
> It should be 'blk_fs_request() || blk_discard_rq()'.
> This patch does it and fixes the no diskstat problem.
> Please review and apply.

Oops, thanks! Applied.

-- 
Jens Axboe

