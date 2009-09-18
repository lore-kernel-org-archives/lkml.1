Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZIRKpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZIRKpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 06:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZIRKph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 06:45:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53988 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZIRKpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 06:45:36 -0400
Date: Fri, 18 Sep 2009 12:45:39 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] Add a tracepoint for block request remapping
Message-ID: <20090918104539.GX23126@kernel.dk>
References: <4AB2E57B.2090101@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB2E57B.2090101@ce.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 18 2009, Jun'ichi Nomura wrote:
> Since 2.6.31 now has request-based device-mapper, it's useful to have
> a tracepoint for request-remapping as well as bio-remapping.
> 
> This patch adds a tracepoint for request-remapping, trace_block_rq_remap().
> Existing trace_block_remap() is left unchanged but it might be better to
> rename it to trace_block_bio_remap().

This looks good, we should definitely have a remap trace at that level
too. Apart from that, nothing further to add than acking the observation
that you need to make the ->device_to part of the trace endian clean.

If you resend with that and just send the core bit (the dm part should
go through the dm branch), then I'll include it for 2.6.32.

-- 
Jens Axboe

