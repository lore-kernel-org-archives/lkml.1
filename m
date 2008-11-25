Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbYKYQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbYKYQj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 11:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752107AbYKYQjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 11:39:17 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40320 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYKYQjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 11:39:16 -0500
Message-ID: <492C2A2F.9070309@garzik.org>
Date: Tue, 25 Nov 2008 11:39:11 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/7] drivers/ata/pata_radisys.c: cleanup kernel-doc
References: <491feb5b.08486e0a.075a.4c48@mx.google.com>
In-Reply-To: <491feb5b.08486e0a.075a.4c48@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Qinghuang Feng wrote:
> No argument named @isich in radisys_set_dmamode,
> remove it.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/drivers/ata/pata_radisys.c b/drivers/ata/pata_radisys.c
> index 0b0aa45..695d44a 100644
> --- a/drivers/ata/pata_radisys.c
> +++ b/drivers/ata/pata_radisys.c
> @@ -81,7 +81,6 @@ static void radisys_set_piomode (struct ata_port *ap, struct ata_device *adev)
>   *	radisys_set_dmamode - Initialize host controller PATA DMA timings
>   *	@ap: Port whose timings we are configuring
>   *	@adev: Device to program
> - *	@isich: True if the device is an ICH and has IOCFG registers
>   *
>   *	Set MWDMA mode for device, in host controller PCI config space.
>   *

applied 1-7 to #upstream, after combining into a single patch.  I felt a 
single changeset was more appropriate.


