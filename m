Return-Path: <linux-kernel-owner+w=401wt.eu-S1423091AbXD3HBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423091AbXD3HBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161659AbXD3HBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:01:37 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7413 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161656AbXD3HBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:01:37 -0400
Date: Mon, 30 Apr 2007 08:57:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS  is under heavy write load (massive starvation)
Message-ID: <20070430065719.GD21015@kernel.dk>
References: <1177660767.6567.41.camel@Homer.simpson.net> <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org> <Pine.LNX.4.64.0704280824420.2502@artax.karlin.mff.cuni.cz> <alpine.LFD.0.98.0704280849150.9964@woody.linux-foundation.org> <20070428163740.GA17061@elte.hu> <Pine.LNX.4.64.0704281909320.14529@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704281909320.14529@artax.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28 2007, Mikulas Patocka wrote:
> >So perhaps if there's any privileged reads going on then we should limit
> >writes to a depth of 2 at most, with some timeout mechanism that would
> 
> SCSI has a "high priority" bit in the command block, so you can just set 
> it --- but I am not sure how well do disks support it.

I'd be surprised if it was useful.

-- 
Jens Axboe

