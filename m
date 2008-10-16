Return-Path: <linux-kernel-owner+w=401wt.eu-S1754090AbYJPFoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbYJPFoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbYJPFor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:44:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55110 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbYJPFor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:44:47 -0400
Date: Thu, 16 Oct 2008 07:44:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: gshan <gshan@alcatel-lucent.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how to limit number of sectors each time
Message-ID: <20081016054400.GN19428@kernel.dk>
References: <48F6B51B.2000408@alcatel-lucent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F6B51B.2000408@alcatel-lucent.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16 2008, gshan wrote:
> Hi All,
> 
> I want to limit requested sectors each time in function 
> drivers/ide/ide-disk.c::__ide_do_rw_disk. The requested
> sectors were defined in rq->nr_sectors. So how to limit or decrease 
> nr_sectors for data transfer each time?

Set max_sectors_kb in sysfs for that device or q->max_sectors
internally.

-- 
Jens Axboe

