Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXKMPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXKMPkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756427AbXKMPkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:40:19 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35594 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755732AbXKMPkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:40:18 -0500
Date: Tue, 13 Nov 2007 15:39:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3]: tty - fix network driver interactions with
 TCGET/SET calls
Message-ID: <20071113153933.2e56057d@the-village.bc.nu>
In-Reply-To: <20071112212315.e23dfe7d.akpm@linux-foundation.org>
References: <20071102153329.1a236477@the-village.bc.nu>
	<20071112212315.e23dfe7d.akpm@linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> net/irda/irnet/irnet_ppp.c: In function 'dev_irnet_ioctl':
> net/irda/irnet/irnet_ppp.c:738: warning: passing argument 2 of 'kernel_termios_to_user_termios_1' from incompatible pointer type
> net/irda/irnet/irnet_ppp.c:750: warning: passing argument 1 of 'user_termios_to_kernel_termios_1' from incompatible pointer type


net/irda isn't tty layer and is completely and totally hosed, has been
for ages. It fakes some tty bits to fool pppd and does it wrong.

The warnings are good - they are showing up real standing bugs.
Unfortunately as its not a real tty device they are not at all easy to
fix.

Alan
