Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYHVGMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYHVGMM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 02:12:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755861AbYHVGLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 02:11:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50860 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103AbYHVGLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 02:11:44 -0400
Message-ID: <48AE589D.7080100@pobox.com>
Date: Fri, 22 Aug 2008 02:11:41 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Seth Heasley <seth.heasley@intel.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [PATCH 2.6.26.2][RESEND] ata_piix: IDE Mode SATA patch for Intel
 Ibex Peak DeviceIDs
References: <200808111703.18252.seth.heasley@intel.com>
In-Reply-To: <200808111703.18252.seth.heasley@intel.com>
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
> This patch adds the Intel Ibex Peak (PCH) IDE mode SATA Controller DeviceIDs.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.26.2/drivers/ata/ata_piix.c.orig	2008-08-08 11:34:56.000000000 -0700
> +++ linux-2.6.26.2/drivers/ata/ata_piix.c	2008-08-08 14:30:02.000000000 -0700
> @@ -274,6 +274,14 @@
>  	{ 0x8086, 0x3a20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>  	/* SATA Controller IDE (ICH10) */
>  	{ 0x8086, 0x3a26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	/* SATA Controller IDE (PCH) */
> +	{ 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
> +	/* SATA Controller IDE (PCH) */
> +	{ 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	/* SATA Controller IDE (PCH) */
> +	{ 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	/* SATA Controller IDE (PCH) */
> +	{ 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },

applied


