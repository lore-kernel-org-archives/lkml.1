Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbYIHQQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbYIHQQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYIHQQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:16:10 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:37742 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbYIHQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:16:09 -0400
Message-ID: <48C54FC6.6030109@pobox.com>
Date: Mon, 08 Sep 2008 12:16:06 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc4] ahci: RAID mode SATA patch for Intel Ibex
 Peak DeviceIDs
References: <200808271647.22782.seth.heasley@intel.com>
In-Reply-To: <200808271647.22782.seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Heasley wrote:
> This patch adds the Intel Ibex Peak (PCH) SATA RAID Controller DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6/drivers/ata/ahci.c.orig	2008-08-27 11:48:10.000000000 -0700
> +++ linux-2.6/drivers/ata/ahci.c	2008-08-27 11:49:23.000000000 -0700
> @@ -487,7 +487,9 @@
>  	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
>  	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
>  	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
> +	{ PCI_VDEVICE(INTEL, 0x3b25), board_ahci }, /* PCH RAID */
>  	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
> +	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */

applied


