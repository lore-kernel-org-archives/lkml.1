Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbYHQXT5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbYHQXT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 19:19:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbYHQXTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 19:19:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48556 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYHQXTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 19:19:50 -0400
Message-ID: <48A8B211.8030103@pobox.com>
Date: Sun, 17 Aug 2008 19:19:45 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Matt_Domsch@dell.com, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] ata: Add support for Long Logical Sectors and Long Physical
 Sectors
References: <1217957207-23116-1-git-send-email-matthew@wil.cx> <1217957207-23116-3-git-send-email-matthew@wil.cx>
In-Reply-To: <1217957207-23116-3-git-send-email-matthew@wil.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> ATA 8 adds support for devices that have sector sizes larger than 512
> bytes.  We record the sector size in the ata_device and use it instead
> of the ATA_SECT_SIZE when the data transfer is a multiple of sectors.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/ata/libata-core.c |  127 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/ata/libata-scsi.c |   52 +++++++++++++-----
>  include/linux/libata.h    |    4 +-
>  3 files changed, 168 insertions(+), 15 deletions(-)

Was this ever updated regarding Alan's final comments?

I only have this patch (the one initiating the email sub-thread).

	Jeff



