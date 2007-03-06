Return-Path: <linux-kernel-owner+w=401wt.eu-S933120AbXCFJF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120AbXCFJF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 04:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbXCFJF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 04:05:58 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51817 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933114AbXCFJF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 04:05:56 -0500
Message-ID: <45ED2EF2.5080002@garzik.org>
Date: Tue, 06 Mar 2007 04:05:54 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jason Gaston <jason.d.gaston@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21-rc2] ahci: RAID mode SATA patch for Intel ICH9M
References: <200611211655.58451.jason.d.gaston@intel.com> <200703021739.47147.jason.d.gaston@intel.com>
In-Reply-To: <200703021739.47147.jason.d.gaston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Gaston wrote:
> This patch adds the Intel ICH9M RAID controller DID for SATA support.
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.21-rc2/drivers/ata/ahci.c.orig	2007-03-02 17:28:00.000000000 
> -0800
> +++ linux-2.6.21-rc2/drivers/ata/ahci.c	2007-03-02 17:28:30.000000000 -0800
> @@ -380,6 +380,7 @@
>  	{ PCI_VDEVICE(INTEL, 0x2929), board_ahci_pi }, /* ICH9M */
>  	{ PCI_VDEVICE(INTEL, 0x292a), board_ahci_pi }, /* ICH9M */
>  	{ PCI_VDEVICE(INTEL, 0x292b), board_ahci_pi }, /* ICH9M */
> +	{ PCI_VDEVICE(INTEL, 0x292c), board_ahci_pi }, /* ICH9M */
>  	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
>  	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */

applied


