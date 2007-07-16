Return-Path: <linux-kernel-owner+w=401wt.eu-S1764305AbXGPQCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764305AbXGPQCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 12:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758647AbXGPQCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 12:02:15 -0400
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:58830 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbXGPQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 12:02:14 -0400
Date: Mon, 16 Jul 2007 19:02:09 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: John Stoffel <john@stoffel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/33] SG table chaining support
In-Reply-To: <yq1d4ysv35d.fsf@sermon.lab.mkp.net>
Message-ID: <Pine.LNX.4.64.0707161852380.5065@kai.makisara.local>
References: <11845792671245-git-send-email-jens.axboe@oracle.com>
 <18075.31515.974905.507754@stoffel.org> <yq1d4ysv35d.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Martin K. Petersen wrote:

> >>>>> "John" == John Stoffel <john@stoffel.org> writes:
> 
> John> Will this help out tape drive performance at all?  I looked
> John> through the patches quickly, esp the AIC7xxx stuff since that's
> John> what I use, but nothing jumped out at me...
> 
> Yes.  Most modern tape drives want a block size of 1MB or higher.
> With the old stack we'd be stuck at 512KB because the sg limitations
> caused us to come just short of 1MB...
> 
Tape block sizes up to 16 MB have been possible for a very long time but 
this has required tuning of the block/scsi parameters. Very few people 
seem to have done this and the common (mis)belief seems to be that the 
tape block size limit has been 512 kB. It is good if this tuning is not
needed in future.

-- 
Kai
