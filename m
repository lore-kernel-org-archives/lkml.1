Return-Path: <linux-kernel-owner+w=401wt.eu-S936649AbXLRALG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936649AbXLRALG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 19:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755440AbXLRAKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 19:10:54 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47936 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589AbXLRAKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 19:10:54 -0500
Date: Tue, 18 Dec 2007 00:04:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Oliver Joa <oliver@j-o-a.de>, linux-kernel@vger.kernel.org
Subject: Re: How to Switch DMA off for only one Harddisk at Kernelboot
Message-ID: <20071218000405.19d2c706@the-village.bc.nu>
In-Reply-To: <20071217223225.GF2310@csclub.uwaterloo.ca>
References: <4765690C.6010605@j-o-a.de>
	<20071217223225.GF2310@csclub.uwaterloo.ca>
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

> Isn't it more a matter of having a CF card that does do DMA and a
> controller that does DMA, but a CF to IDE adapter that does not do DMA?

Usually yes. 

If your CF card doesn't support DMA it will advertise PIO modes only and
all will be well. If your card can do DMA it will advertise DMA modes
regardless of whether your CF adapter has the needed pins wired.

For UDMA it is even worse. Most CF adapters that can do DMA do not
provide sufficient signal quality for UDMA. In addition if you hang them
off a normal UDMA 2 device cable you are miles out of spec and some cards
work some of the time.

Alan
