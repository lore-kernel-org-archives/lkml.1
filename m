Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907Ab0ATT2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab0ATT2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 14:28:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503Ab0ATT2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 14:28:53 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:61340 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0ATT2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:28:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x2+jkScH/ieLxs6dEpRFSkRiNO+0ObUMnBI+Aac8P1htxs4+OJPDPKbNIb34hzlc0y
         f5Xu9Z/+/CRr/IOsUoXZW5dEUpcA/ygh8t5lW6DFRKuhE9NJtldnna2LCdWHng6/cOAJ
         v5anVBpr01ssvjKlhPG7MdCjXOr//PX6k3jA0=
Message-ID: <4B575971.2090009@pobox.com>
Date: Wed, 20 Jan 2010 14:28:49 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.32.3] ahci: AHCI and RAID mode SATA patch for Intel
 Cougar Point DeviceIDs
References: <201001121700.18234.seth.heasley@intel.com>
In-Reply-To: <201001121700.18234.seth.heasley@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2010 08:00 PM, Seth Heasley wrote:
> This patch adds the Intel Cougar Point (PCH) SATA AHCI and RAID Controller DeviceIDs.
>
> Signed-off-by: Seth Heasley<seth.heasley@intel.com>
>
> --- linux-2.6.32.3/drivers/ata/ahci.c.orig	2010-01-06 15:07:45.000000000 -0800
> +++ linux-2.6.32.3/drivers/ata/ahci.c	2010-01-07 13:55:23.000000000 -0800
> @@ -560,6 +560,12 @@
>   	{ PCI_VDEVICE(INTEL, 0x3b2b), board_ahci }, /* PCH RAID */
>   	{ PCI_VDEVICE(INTEL, 0x3b2c), board_ahci }, /* PCH RAID */
>   	{ PCI_VDEVICE(INTEL, 0x3b2f), board_ahci }, /* PCH AHCI */
> +	{ PCI_VDEVICE(INTEL, 0x1c02), board_ahci }, /* CPT AHCI */
> +	{ PCI_VDEVICE(INTEL, 0x1c03), board_ahci }, /* CPT AHCI */
> +	{ PCI_VDEVICE(INTEL, 0x1c04), board_ahci }, /* CPT RAID */
> +	{ PCI_VDEVICE(INTEL, 0x1c05), board_ahci }, /* CPT RAID */
> +	{ PCI_VDEVICE(INTEL, 0x1c06), board_ahci }, /* CPT RAID */
> +	{ PCI_VDEVICE(INTEL, 0x1c07), board_ahci }, /* CPT RAID */

applied this, and the ata_piix patch


