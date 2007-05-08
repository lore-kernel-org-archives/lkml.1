Return-Path: <linux-kernel-owner+w=401wt.eu-S968091AbXEHOGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968091AbXEHOGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 10:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968077AbXEHOGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 10:06:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:45331 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967873AbXEHOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 10:06:49 -0400
Date: Tue, 8 May 2007 16:04:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Rene Herman <rene.herman@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New Mitsumi legacy CD-ROM driver
Message-ID: <20070508140432.GS4163@kernel.dk>
References: <464045F0.3040906@gmail.com> <20070508103524.GH4163@kernel.dk> <46407D75.7050603@gmail.com> <20070508134944.GO4163@kernel.dk> <Pine.LNX.4.64.0705081656570.31629@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0705081656570.31629@sbz-30.cs.Helsinki.FI>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08 2007, Pekka J Enberg wrote:
> On Tue, 8 May 2007, Jens Axboe wrote:
> > IOW, you are always better off not supporting highmem for this driver.
> > The fact that it also simplifies the handling is a bonus.
> 
> Agreed. So we should just use BLK_BOUNCE_HIGH, right?

Yeah, just remove the call to blk_queue_bounce_limit() completely, the
block layer has always defaulted to that.

> On Tue, 8 May 2007, Jens Axboe wrote:
> > Fine with me... As far as I am concerned, you are now the legacy CD-ROM
> > driver maintainer :-)
> 
> Poor Rene... ;-)

I'll be expecting a MAINTAINERS patch :-)

-- 
Jens Axboe

