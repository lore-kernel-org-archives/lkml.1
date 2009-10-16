Return-Path: <linux-kernel-owner+w=401wt.eu-S1757828AbZJPK1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbZJPK1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 06:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbZJPK1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 06:27:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44573 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZJPK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 06:27:33 -0400
Message-ID: <4AD84A6D.5070600@garzik.org>
Date: Fri, 16 Oct 2009 06:26:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: peer chen <peerchen@gmail.com>
CC: linux-ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>, pchen@nvidia.com
Subject: Re: [PATCH] ahci: Add the AHCI controller Linux Device ID for NVIDIA
 	chipsets.
References: <cfaab6210910150134q6cc2d5ffna39cf31bf89a8e2@mail.gmail.com>
In-Reply-To: <cfaab6210910150134q6cc2d5ffna39cf31bf89a8e2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 04:34 AM, peer chen wrote:
> Add the generic device ID for NVIDIA AHCI controller.
>
> Signed-off-by: Peer Chen<peerchen@gmail.com>
> ---
> --- linux-2.6.32-rc4/drivers/ata/ahci.c.orig
> +++ linux-2.6.32-rc4/drivers/ata/ahci.c
> @@ -605,6 +605,7 @@ static const struct pci_device_id ahci_p
>   	{ PCI_VDEVICE(NVIDIA, 0x0559), board_ahci_yesncq },	/* MCP67 */
>   	{ PCI_VDEVICE(NVIDIA, 0x055a), board_ahci_yesncq },	/* MCP67 */
>   	{ PCI_VDEVICE(NVIDIA, 0x055b), board_ahci_yesncq },	/* MCP67 */
> +	{ PCI_VDEVICE(NVIDIA, 0x0580), board_ahci_yesncq },	/* Linux ID */
>   	{ PCI_VDEVICE(NVIDIA, 0x07f0), board_ahci_yesncq },	/* MCP73 */
>   	{ PCI_VDEVICE(NVIDIA, 0x07f1), board_ahci_yesncq },	/* MCP73 */
>   	{ PCI_VDEVICE(NVIDIA, 0x07f2), board_ahci_yesncq },	/* MCP73 */

applied


