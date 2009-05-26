Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZEZQlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZEZQlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754947AbZEZQlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:41:17 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48100 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170AbZEZQlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:41:16 -0400
Date: Tue, 26 May 2009 18:41:17 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 0/12] Per-bdi writeback flusher threads v7
Message-ID: <20090526164117.GJ11363@kernel.dk>
References: <1243330430-9964-1-git-send-email-jens.axboe@oracle.com> <20090526152501.GA20968@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526152501.GA20968@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26 2009, Damien Wyart wrote:
> Hello,
> 
> I have been playing with v7 since your sending and after a white (short
> on laptop, longer on desktop, a few hours), writeback doesn't seem to
> work anymore. Manual call to sync hangs (process in D state) and Dirty
> value in meminfo gets growing. As previous versions had been heavily
> tested, I guess there is some regression in v7.

Not good, the prime suspect is the sync notification stuff. I'll take a
look and get that fixed. You didn't happen to catch any sysrq-t back
traces or anything like that? Would be interesting to see where where
bdi-default and the bdi-* threads are stuck.

Can you send me your .config and a dmesg from a booted system? Any
kernel, doesn't have to be the writeback kernel.

-- 
Jens Axboe

