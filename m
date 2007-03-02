Return-Path: <linux-kernel-owner+w=401wt.eu-S2992726AbXCBXR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992726AbXCBXR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992728AbXCBXR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:17:57 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:54590 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992726AbXCBXR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:17:56 -0500
Message-ID: <45E8B0A2.5020905@garzik.org>
Date: Fri, 02 Mar 2007 18:17:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_cmd64x - various fixes
References: <20070301175939.3dfc25e6@lxorguk.ukuu.org.uk>
In-Reply-To: <20070301175939.3dfc25e6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> This driver still needs more work but for the moment
> 
> - It's a CMD not ATI driver
> - Clean up code by using cable method
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2/drivers/ata/pata_cmd64x.c linux-2.6.21-rc2/drivers/ata/pata_cmd64x.c
> --- linux.vanilla-2.6.21-rc2/drivers/ata/pata_cmd64x.c	2007-03-01 13:36:03.000000000 +0000
> +++ linux-2.6.21-rc2/drivers/ata/pata_cmd64x.c	2007-03-01 14:49:51.491226440 +0000
> @@ -1,5 +1,5 @@
>  /*
> - * pata_cmd64x.c 	- ATI PATA for new ATA layer
> + * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
>   *			  (C) 2005 Red Hat Inc
>   *			  Alan Cox <alan@redhat.com>
>   *

applied this tiny bit, will await resend of the rest in the jumbo 
cable-detect-driver-update patch

