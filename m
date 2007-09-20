Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbXITVfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbXITVfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXITVfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:35:25 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55926 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXITVfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:35:24 -0400
Message-ID: <46F2E799.4020303@pobox.com>
Date: Thu, 20 Sep 2007 17:35:21 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jason Gaston <jason.d.gaston@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-rc4][reRESEND] ahci: RAID mode SATA patch for Intel
 Tolapai
References: <200708302127.19535.jason.d.gaston@intel.com>
In-Reply-To: <200708302127.19535.jason.d.gaston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Gaston wrote:
> Resend trying to remove 8-bit characters in the email.
> 
> This patch adds the Intel Tolapai RAID controller DID's for SATA support.
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.23-rc4/drivers/ata/ahci.c.orig	2007-08-27 18:32:35.000000000 -0700
> +++ linux-2.6.23-rc4/drivers/ata/ahci.c	2007-08-28 16:58:11.000000000 -0700
> @@ -411,6 +411,8 @@
>  	{ PCI_VDEVICE(INTEL, 0x292f), board_ahci_pi }, /* ICH9M */
>  	{ PCI_VDEVICE(INTEL, 0x294d), board_ahci_pi }, /* ICH9 */
>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci_pi }, /* ICH9M */
> +	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
> +	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */

applied manually, since it conflicted with Tejun's PI patch (not your fault)


