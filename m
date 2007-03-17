Return-Path: <linux-kernel-owner+w=401wt.eu-S933823AbXCQNBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbXCQNBZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 09:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965268AbXCQNBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 09:01:25 -0400
Received: from userg504.nifty.com ([202.248.238.84]:54123 "EHLO
	userg504.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823AbXCQNBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 09:01:24 -0400
DomainKey-Signature: a=rsa-sha1; s=userg504; d=nifty.com; c=nofws; q=dns;
	b=Sf9tjJTeApL015U3ZeAig2MlB/zgxx2lPL9Kl474J6af8PU2HPRBAva+kLEYNsv7w
	u8BVHiKcD3RKU67UwSBFA==
Date: Sat, 17 Mar 2007 22:00:50 +0900
From: Komuro <komurojun-mbn@nifty.com>
To: linux-kernel@vger.kernel.org
Cc: alan@lxorguk.ukuu.org.uk
Subject: [BUG]  PATA_PCMCIA  cmd port
Message-Id: <20070317220050.380d9f51.komurojun-mbn@nifty.com>
In-Reply-To: <20070211101537.e40fa309.komurojun-mbn@nifty.com>
References: <20061217212752.d93816b4.komurojun-mbn@nifty.com>
	<20061217040222.GD17561@ftp.linux.org.uk>
	<20070211101537.e40fa309.komurojun-mbn@nifty.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
 
The pata_pcmcia driver reports the cmd port is 0x00010100,
but actually the cmd port is 0x0100.

Is this corect?

>ata1: PATA max PIO0 cmd 0x00010100 ctl 0x0001010e bmdma 0x00000000 irq 3
                               ^^^^^^^^^^^^^      ^^^^^^^^^^^^^

Best Regards
Komuro

