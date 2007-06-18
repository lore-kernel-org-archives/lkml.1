Return-Path: <linux-kernel-owner+w=401wt.eu-S932908AbXFRU7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908AbXFRU7U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763449AbXFRU7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:59:07 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:33887 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764150AbXFRU7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:59:06 -0400
Date: Mon, 18 Jun 2007 22:04:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linas@austin.ibm.com (Linas Vepstas)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070618220441.3a3af8ca@the-village.bc.nu>
In-Reply-To: <20070618204601.GF5836@austin.ibm.com>
References: <20070618175713.GD5836@austin.ibm.com>
	<20070618212704.394912b8@the-village.bc.nu>
	<20070618204601.GF5836@austin.ibm.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So what do you suggest? (I could buy an alternate ide controller,
> and hope that goes away, or just buy a different hard drive. But
> that's beside the point).

The DMA timeout itself could be all sorts of things - crap driver, crap
hardware, PCI bus contention, noise, problem disk, phase of the moon.

> I can prepare a patch, but only with a lot of guidance. I can test 
> & debug, I'm highly motivated just right now ... 

If you've got a nice repeatable problem please try using the libata
driver. That handles the error paths differently and doesn't try a FIFO
drain which might matter in this case I guess.

Alan
