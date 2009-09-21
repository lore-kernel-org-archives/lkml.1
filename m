Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZIUNIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZIUNIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbZIUNIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:08:50 -0400
Received: from mga03.intel.com ([143.182.124.21]:33205 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756034AbZIUNIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:08:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,424,1249282800"; 
   d="scan'208";a="189861536"
Date: Mon, 21 Sep 2009 21:08:43 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "jack@suse.cz" <jack@suse.cz>
Subject: Re: [GIT PULL] a few writeback fixes
Message-ID: <20090921130843.GA15645@localhost>
References: <20090921125620.GV23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921125620.GV23126@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 08:56:20PM +0800, Jens Axboe wrote:
> Hi Linus,
> 
> This fixes a problem with NFS killing its bdi without being initialized,
> and also contains a fix for a busy loop (where we forgot to set the
> task state before sleeping). Since these are a bit critical for -rc1,
> I'm pushing them out before leaving for Portland.

Jens, I confirmed that it fixed the problem I encountered.

Thanks,
Fengguang

