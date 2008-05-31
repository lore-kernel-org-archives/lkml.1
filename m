Return-Path: <linux-kernel-owner+w=401wt.eu-S1755012AbYEaB53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012AbYEaB53 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYEaB5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:57:21 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:36745 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYEaB5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:57:21 -0400
Message-ID: <4840B077.70705@pobox.com>
Date: Fri, 30 May 2008 21:57:11 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2 of 5] xn/blkfront: Add the CDROM_GET_CAPABILITY ioctl
 to	blkfront
References: <84dc2b8e1677cbc6f5ec.1212192092@localhost>
In-Reply-To: <84dc2b8e1677cbc6f5ec.1212192092@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> +	case CDROM_GET_CAPABILITY: {
> +		struct gendisk *gd = info->gd;
> +		if (gd->flags & GENHD_FL_CD)
> +			return 0;
> +		return -EINVAL;
> +	}


Surely you can come up with a better implementation than this?  It's 
just a bitmask returned to userspace...

	Jeff


