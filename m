Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbXCDVlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbXCDVlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 16:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbXCDVlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 16:41:53 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39244 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752500AbXCDVlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 16:41:52 -0500
Date: Sun, 4 Mar 2007 22:43:55 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-hams@vger.kernel.org, sailer@ife.ee.ethz.ch, henk.termeer@gmail.com,
       udovdh@xs4all.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] baycom_ser_fdx: also allow i/o ports >= 0x1000 and
 enhanced failure logging
Message-ID: <20070304224355.19308ec0@lxorguk.ukuu.org.uk>
In-Reply-To: <20070304213034.GU10782@vanheusden.com>
References: <20070304213034.GU10782@vanheusden.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The baycom_ser_fdx driver did not allow i/o ports >= 0x1000. Now that
> there are pci cards (with rs232 ports) which use for example 0xb800 this
> limit should not exists.

The IRQ test is also wrong for PCI systems the moment an APIC is present.
NR_IRQS is the define to use.

> Also, for non kernel coders find the cause of problems was challenging
> so I added extra logging.
