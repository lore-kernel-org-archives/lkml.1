Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZIPG3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZIPG3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 02:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbZIPG3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 02:29:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:50228 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbZIPG3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 02:29:46 -0400
Date: Wed, 16 Sep 2009 08:29:49 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Limit blk_iopoll sysctl to CONFIG_BLOCK=y.
Message-ID: <20090916062949.GA23126@kernel.dk>
References: <20090916062627.GB5805@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916062627.GB5805@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, Paul Mundt wrote:
> blk_iopoll_enabled is defined in block/blk-iopoll.c, which is only built
> in the CONFIG_BLOCK=y case. Make the sysctl depend on this, too.
> 
> Fixes up the CONFIG_BLOCK=n build.

Already sent in, but Linus hasn't pulled it yet.


-- 
Jens Axboe

