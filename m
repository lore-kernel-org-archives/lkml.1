Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZJ0FbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZJ0FbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 01:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZJ0FbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 01:31:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46960 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752090AbZJ0FbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 01:31:05 -0400
Date: Tue, 27 Oct 2009 06:31:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: block tree build failure
Message-ID: <20091027053109.GO10727@kernel.dk>
References: <20091027143433.bfe08a1b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091027143433.bfe08a1b.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next build (x86_64 allmodconfig) failed like this:
> 
> drivers/block/drbd/drbd_req.c: In function '_drbd_start_io_acct':
> drivers/block/drbd/drbd_req.c:43: error: lvalue required as increment operand
> drivers/block/drbd/drbd_req.c: In function '_drbd_end_io_acct':
> drivers/block/drbd/drbd_req.c:56: error: lvalue required as decrement operand
> 
> This is the dual in_flight changes breaking again ... I have used the
> block tree from next-20091026 for today.

Sorry, not sure why that problem seems so persistent, I just merged the
newer bits in. Will fix it.

-- 
Jens Axboe

