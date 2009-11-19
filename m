Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZKSX1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZKSX1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 18:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZKSX1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 18:27:08 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51648 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755233AbZKSX1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 18:27:07 -0500
Message-ID: <4B05D44B.9010606@garzik.org>
Date: Thu, 19 Nov 2009 18:27:07 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: linux-ide@vger.kernel.org,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>
Subject: Re: [PATCH v2] ata: New PATA driver for Altera CompactFlash.
References: <1254967110-3495-1-git-send-email-thomas@wytron.com.tw>
In-Reply-To: <1254967110-3495-1-git-send-email-thomas@wytron.com.tw>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2009 09:58 PM, Thomas Chou wrote:
> This patch adds a new PATA driver to support the Altera SOPC Builder
> CompactFlash component as a PATA device with support for insertion
> and removal of CF cards.  It uses the platform driver model.
>
> For each probed platform device, the driver spawns a kthread to
> handle insertion and removal of CF cards by creating and removing the
> underlying ATA host interface.  The Altera CompactFlash component
> includes a register bit to indicate whether a CF card is detected
> and an interrupt triggered when this bit changes.  The driver has a
> handler for this interrupt which flags that something has changed and
> wakes up the kthread to deal with it.
>
> The platform device uses 2 IORESOURCE_MEM resources and 2
> IORESOURCE_IRQ resources.  The first memory resource is for the
> CompactFlash component's IDE registers and the second is for the
> component's CF status and control registers.  The first IRQ resource
> is for the IDE and the second is for the CF detection interrupt.
>
> Signed-off-by: Ian Abbott<abbotti@mev.co.uk>
> Signed-off-by: Thomas Chou<thomas@wytron.com.tw>
> ---
>   drivers/ata/Kconfig          |   11 +
>   drivers/ata/Makefile         |    1 +
>   drivers/ata/pata_altera_cf.c |  582 ++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 594 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/ata/pata_altera_cf.c

Ping...  still waiting on v3, updated with Alan's feedback.


