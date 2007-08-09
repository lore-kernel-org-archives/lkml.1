Return-Path: <linux-kernel-owner+w=401wt.eu-S965873AbXHIOqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965873AbXHIOqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXHIOqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:46:04 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41271 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965521AbXHIOqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:46:01 -0400
Date: Thu, 9 Aug 2007 15:53:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: chuck.lever@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: DMA CRC errors with SiS chipset and notebook drive
Message-ID: <20070809155324.3a9499ca@the-village.bc.nu>
In-Reply-To: <46BB190E.2030102@oracle.com>
References: <46BB190E.2030102@oracle.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Aug  9 07:41:29 monet kernel: ata1.00: limiting speed to UDMA/66:PIO4
> Aug  9 07:41:29 monet kernel: ata1.00: exception Emask 0x0 SAct 0x0 SErr
> 0x0 action 0x2
> Aug  9 07:41:29 monet kernel: ata1.00: (BMDMA stat 0x64)
> Aug  9 07:41:29 monet kernel: ata1.00: cmd
> c8/00:08:fb:7c:a1/00:00:00:00:00/e0 tag 0 cdb 0x12 data 4096 in
> Aug  9 07:41:29 monet kernel:          res
> 51/84:00:00:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> Aug  9 07:41:29 monet kernel: ata1: soft resetting port
> Aug  9 07:41:29 monet kernel: ata1.00: configured for UDMA/66
> Aug  9 07:41:29 monet kernel: ata1.01: configured for UDMA/33
> Aug  9 07:41:29 monet kernel: ata1: EH complete

Drops to UDMA33 for 40 wire cable.


Looks to me like your cabling is out of spec or you have electrical noise
problems.

Alan
