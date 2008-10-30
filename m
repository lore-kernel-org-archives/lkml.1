Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYJ3IAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYJ3IAY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbYJ3IAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:00:09 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51495 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbYJ3IAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:00:07 -0400
Date: Thu, 30 Oct 2008 08:58:56 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not elv_next_request()
Message-ID: <20081030075855.GO31673@kernel.dk>
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk> <49096865.2050006@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49096865.2050006@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30 2008, Tejun Heo wrote:
> Jens Axboe wrote:
> > That's actually a pretty dumb error, I'm surprised it hasn't reared its
> > ugly face in more ways. Presumably because the timeout is usually so
> > long, that we'll get to actually issuing and completing it within the
> > normal timeout anyway.
> 
> Heh... it showed its ugly face in many different ways while I was
> playing with PMP connected via a very long eSATA cable.

Ah :-)

If we had it wired up for eg the old IDE drivers, it would have shown up
quite quickly as well I think.

-- 
Jens Axboe

