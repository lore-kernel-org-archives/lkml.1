Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbYJ3Hzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbYJ3Hzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYJ3Hze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:55:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:47630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbYJ3Hzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:55:33 -0400
Message-ID: <49096865.2050006@kernel.org>
Date: Thu, 30 Oct 2008 16:55:17 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH] block: add timer on blkdev_dequeue_request() not elv_next_request()
References: <490927CD.2010205@kernel.org> <20081030072956.GL31673@kernel.dk>
In-Reply-To: <20081030072956.GL31673@kernel.dk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Oct 2008 07:55:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> That's actually a pretty dumb error, I'm surprised it hasn't reared its
> ugly face in more ways. Presumably because the timeout is usually so
> long, that we'll get to actually issuing and completing it within the
> normal timeout anyway.

Heh... it showed its ugly face in many different ways while I was
playing with PMP connected via a very long eSATA cable.

Thanks.  :-)

-- 
tejun
