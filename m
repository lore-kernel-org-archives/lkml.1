Return-Path: <linux-kernel-owner+w=401wt.eu-S2992680AbXDDGIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992680AbXDDGIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992683AbXDDGIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:08:51 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41631 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992680AbXDDGIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:08:50 -0400
Message-ID: <461340E5.2070901@garzik.org>
Date: Wed, 04 Apr 2007 02:08:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Mark Lord <mlord@pobox.com>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <htejun@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: libata bugfix: preserve LBA bit for HDIO_DRIVE_TASK
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com> <460D8510.1050102@pobox.com>
In-Reply-To: <460D8510.1050102@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Ideally, this would go into linux-2.6.21.
> 
> Preserve the LBA bit in the DevSel/Head register for HDIO_DRIVE_TASK.
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com>
> ---
> --- linux/drivers/ata/libata-scsi.c.orig    2007-03-21 
> 13:35:02.000000000 -0400
> +++ linux/drivers/ata/libata-scsi.c    2007-03-30 17:40:58.000000000 -0400
> @@ -333,7 +333,7 @@
>     scsi_cmd[8]  = args[3];
>     scsi_cmd[10] = args[4];
>     scsi_cmd[12] = args[5];
> -    scsi_cmd[13] = args[6] & 0x0f;
> +    scsi_cmd[13] = args[6] & 0x4f;
>     scsi_cmd[14] = args[0];

applied


