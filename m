Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZD1Doe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZD1Doe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 23:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754985AbZD1DoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 23:44:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:57823 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZD1DoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 23:44:23 -0400
Message-ID: <49F67B87.10103@kernel.org>
Date: Tue, 28 Apr 2009 12:44:07 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Subject: Re: [RFC PATCHSET linux-2.6-block#for-2.6.31] block: lld cleanup
 patches
References: <1240489553-15724-1-git-send-email-tj@kernel.org> <200904242141.56375.bzolnier@gmail.com>
In-Reply-To: <200904242141.56375.bzolnier@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 28 Apr 2009 03:43:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bartlomiej.

Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [RFC][PATCH] mg_disk: fix issue with data integrity on error in mg_write()
> 
> We cannot acknowledge the sector write before checking its status
> (which is done on the next loop iteration) and we also need to do
> the final status register check after writing the last sector.
> 
> Fix mg_write() to match mg_write_intr() in this regard.
> 
> While at it:
> - add mg_read_one() and mg_write_one() helpers
> - always use MG_SECTOR_SIZE and remove MG_STORAGE_BUFFER_SIZE
> 
> Cc: unsik Kim <donari75@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

I folded other three patches into my series.  This one looks good to me
too but unlike others this one actually changes how the driver
interacts with the device so I think it would be better to wait for
unsik's ack on this one (I'm pushing out others).

Thanks.

-- 
tejun
