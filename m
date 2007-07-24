Return-Path: <linux-kernel-owner+w=401wt.eu-S1762007AbXGXMi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762007AbXGXMi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbXGXMiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:38:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55539 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569AbXGXMiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:38:04 -0400
Message-ID: <46A5F275.7060905@garzik.org>
Date: Tue, 24 Jul 2007 08:37:09 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
References: <20070716161539.075822000@pademelon.sonytel.be>	<20070716162206.392129000@pademelon.sonytel.be> <20070718163637.3f0e0164.akpm@linux-foundation.org> <46A5E610.7000508@shadowen.org>
In-Reply-To: <46A5E610.7000508@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> Andrew Morton wrote:
> 
>>> +	start_sector = req->sector*priv->blocking_factor;
>>> +	sectors = req->nr_sectors*priv->blocking_factor;
>> s/*/ * /.  checkpatch missed this.
> 
> Ok, this is something we need to decide on.  Currently we only ask for
> consistent spacing on all the mathematic operators.  This is mostly as
> we do see a large number of non-spaced uses in defines and the like.
> 
> I am happy to expand these tests so they are always spaced on both sides
> style if that is the preference.

That is most definitely the preference:  spaces surround operators.

	Jeff



