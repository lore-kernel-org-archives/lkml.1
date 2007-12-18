Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXLRARS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXLRARS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbXLRAQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:16:58 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33953 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757244AbXLRAQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:16:57 -0500
Date: Tue, 18 Dec 2007 00:10:07 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, devzero@web.de,
       Matt.Domsch@dell.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Message-ID: <20071218001007.2324dbfc@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0712180023310.32270@fbirervta.pbzchgretzou.qr>
References: <49448787@web.de>
	<82e4877d0712161159r2572dbbfi15159c66e4b7e33b@mail.gmail.com>
	<20071216201849.24f7aa5f@the-village.bc.nu>
	<Pine.LNX.4.64.0712180023310.32270@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does printk support escape sequences? The last time I tried
> printk("\e[1;35m omg ponies \e[0m"); that did not went too successful.

It should handle \r correctly. If not that is easy to fix.

Escape codes are bad and should not be used - you may have a serial
console and not be on a Linux console
