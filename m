Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbZDZEEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbZDZEEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 00:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZDZEEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 00:04:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50373 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750748AbZDZEEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 00:04:35 -0400
Message-ID: <49F3DD4F.6080804@garzik.org>
Date: Sun, 26 Apr 2009 00:04:31 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: unsik Kim <donari75@gmail.com>, Tejun Heo <tj@kernel.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 2/3] mg_disk: fix dependency on libata
References: <200904251509.11912.bzolnier@gmail.com>
In-Reply-To: <200904251509.11912.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
> so there is no need for the driver to depend on ATA and SCSI.
> 
> Cc: unsik Kim <donari75@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/block/Kconfig   |    2 +-
>  drivers/block/mg_disk.c |   44 ++++++++++++++++++++++++++++++++++++++++----
>  2 files changed, 41 insertions(+), 5 deletions(-)

Please CC these types of patches to linux-ide also, as it is of interest 
to Linux ATA folks...  thanks.

	Jeff




