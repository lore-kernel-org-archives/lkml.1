Return-Path: <linux-kernel-owner+w=401wt.eu-S933509AbYA2ROq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbYA2ROq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764815AbYA2RON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:14:13 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:35030 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760172AbYA2ROJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:14:09 -0500
Message-ID: <479F5EDF.9010601@pobox.com>
Date: Tue, 29 Jan 2008 12:14:07 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jason Gaston <jason.d.gaston@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [PATCH 2.6.24] ata_piix:  IDE mode SATA patch for Intel ICH10
 DeviceID's
References: <200801281736.45574.jason.d.gaston@intel.com>
In-Reply-To: <200801281736.45574.jason.d.gaston@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Gaston wrote:
> This patch adds the Intel ICH10 IDE mode SATA Controller DeviceID's.
> 
> Signed-off-by:  Jason Gaston <jason.d.gaston@intel.com>
> 
> --- linux-2.6.24/drivers/ata/ata_piix.c.orig	2008-01-24 14:58:37.000000000 -0800
> +++ linux-2.6.24/drivers/ata/ata_piix.c	2008-01-28 14:58:22.000000000 -0800
> @@ -263,6 +263,14 @@
>  	{ 0x8086, 0x292e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
>  	/* SATA Controller IDE (Tolapai) */
>  	{ 0x8086, 0x5028, PCI_ANY_ID, PCI_ANY_ID, 0, 0, tolapai_sata_ahci },
> +	/* SATA Controller IDE (ICH10) */
> +	{ 0x8086, 0x3a00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
> +	/* SATA Controller IDE (ICH10) */
> +	{ 0x8086, 0x3a06, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	/* SATA Controller IDE (ICH10) */
> +	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_ahci },
> +	/* SATA Controller IDE (ICH10) */
> +	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },

can these do AHCI mode without losing any PATA ports?

if so, I would prefer to always drive the hardware in AHCI mode, if it 
is capable of doing so.

