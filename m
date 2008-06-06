Return-Path: <linux-kernel-owner+w=401wt.eu-S1764620AbYFFHys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764620AbYFFHys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763607AbYFFHyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:54:37 -0400
Received: from brick.kernel.dk ([87.55.233.238]:4953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660AbYFFHyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:54:36 -0400
Date: Fri, 6 Jun 2008 09:54:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: blk_queue_hardsect_size 520-byte sector
Message-ID: <20080606075432.GH5757@kernel.dk>
References: <339116.28290.qm@web32404.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <339116.28290.qm@web32404.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05 2008, Anil kumar wrote:
> Hi,
> 
> Can I call blk_queue_hardsect_size in a driver and set it to 520-byte
> as hardware sector size.  How does the kernel and block layers take
> the request, will it be in multiples of 520-bytes aligned or 512 bytes
> aligned?

No, Linux only supports power-of-2 hardware block sizes I'm afraid.

-- 
Jens Axboe

