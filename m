Return-Path: <linux-kernel-owner+w=401wt.eu-S1757439AbYHVGLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbYHVGLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbYHVGLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:11:37 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50856 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbYHVGLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:11:36 -0400
Message-ID: <48AE5894.9010408@pobox.com>
Date: Fri, 22 Aug 2008 02:11:32 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.26.2][RESEND] ahci: RAID mode SATA patch for Intel
 Ibex Peak DeviceIDs
References: <200808111703.09743.seth.heasley@intel.com>
In-Reply-To: <200808111703.09743.seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Heasley wrote:
> Resend with proper whitespace.
> 
> This patch adds the Intel Ibex Peak (PCH) SATA RAID Controller DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.26.2/drivers/ata/ahci.c.orig	2008-08-08 11:34:48.000000000 -0700
> +++ linux-2.6.26.2/drivers/ata/ahci.c	2008-08-08 11:36:06.000000000 -0700
> @@ -445,6 +445,8 @@
>  	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
>  	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
>  	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */
> +	{ PCI_VDEVICE(INTEL, 0x3b24), board_ahci }, /* PCH RAID */
> +	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
>  
>  	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
>  	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,

applied


