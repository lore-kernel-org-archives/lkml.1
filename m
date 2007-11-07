Return-Path: <linux-kernel-owner+w=401wt.eu-S1758193AbXKGNKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193AbXKGNKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 08:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbXKGNKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 08:10:32 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50439 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758011AbXKGNKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:10:30 -0500
Date: Wed, 7 Nov 2007 13:10:36 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH 2/2] libata: pata_platform: Support polling-mode
 configuration.
Message-ID: <20071107131036.184e1c73@the-village.bc.nu>
In-Reply-To: <20071107081119.GB25913@linux-sh.org>
References: <20071107081052.GA25913@linux-sh.org>
	<20071107081119.GB25913@linux-sh.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +	 * Use polling mode if there's no IRQ
> +	 */
> +	if (irq < 0) {
> +		ap->flags |= ATA_FLAG_PIO_POLLING;
> +		ata_port_desc(ap, "no IRQ, using PIO polling");
> +	}
> +
> +	/*

Zero means no IRQ. Not < 0. We enforce that policy across the kernel and
Linus has been very clear about it.

