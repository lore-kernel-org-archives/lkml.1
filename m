Return-Path: <linux-kernel-owner+w=401wt.eu-S1763582AbYALL6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763582AbYALL6z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 06:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbYALL6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 06:58:49 -0500
Received: from brick.kernel.dk ([87.55.233.238]:5643 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920AbYALL6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 06:58:48 -0500
Date: Sat, 12 Jan 2008 12:58:45 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       j-nomura@ce.jp.nec.com
Subject: Re: [PATCH 0/3] block: remove end_{queued|dequeued}_request()
Message-ID: <20080112115845.GI6258@kernel.dk>
References: <20080111.164916.102581473.k-ueda@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111.164916.102581473.k-ueda@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Kiyoshi Ueda wrote:
> Hi Jens,
> 
> This patch set removes end_queued_request() and end_dequeued_request(),
> which became identical by the blk-end-request patch set.
> They just calls __blk_end_request() actually, so users of them are
> converted to call __blk_end_request() directly.

Please just keep them both and call __blk_end_request(), it's nicer as
an exported name. Then we can do a cleanup run afterwards.

-- 
Jens Axboe

