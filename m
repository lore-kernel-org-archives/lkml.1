Return-Path: <linux-kernel-owner+w=401wt.eu-S933404AbYA2RNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbYA2RNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYA2RNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:13:30 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35006 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbYA2RN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:13:29 -0500
Message-ID: <479F5EB6.5030406@pobox.com>
Date: Tue, 29 Jan 2008 12:13:26 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Gaston <jason.d.gaston@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] ahci: RAID mode SATA patch for Intel ICH10 DeviceID's
References: <200801281734.14535.jason.d.gaston@intel.com>
In-Reply-To: <200801281734.14535.jason.d.gaston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Gaston wrote:
> This patch adds the Intel ICH10 SATA RAID Controllers DeviceID's.
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.24/drivers/ata/ahci.c.orig	2008-01-24 14:58:37.000000000 -0800
> +++ linux-2.6.24/drivers/ata/ahci.c	2008-01-28 14:58:22.000000000 -0800
> @@ -475,6 +475,8 @@
>  	{ PCI_VDEVICE(INTEL, 0x294e), board_ahci }, /* ICH9M */
>  	{ PCI_VDEVICE(INTEL, 0x502a), board_ahci }, /* Tolapai */
>  	{ PCI_VDEVICE(INTEL, 0x502b), board_ahci }, /* Tolapai */
> +	{ PCI_VDEVICE(INTEL, 0x3a05), board_ahci }, /* ICH10 */
> +	{ PCI_VDEVICE(INTEL, 0x3a25), board_ahci }, /* ICH10 */

applied


