Return-Path: <linux-kernel-owner+w=401wt.eu-S1762721AbXFJRiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762721AbXFJRiz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbXFJRir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:38:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47287 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753185AbXFJRiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:38:46 -0400
Date: Sun, 10 Jun 2007 18:44:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_it821x: sync with IDE it821x driver
Message-ID: <20070610184405.0cf4373a@the-village.bc.nu>
In-Reply-To: <200706101840.40460.bzolnier@gmail.com>
References: <200706090223.20933.bzolnier@gmail.com>
	<20070610165638.2db56f04@the-village.bc.nu>
	<200706101840.40460.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > NAK this too
> 
> OK, I'm able to understand the meaning of "NAK" [1] but "this too"?

That was me being confusing with something else I NAKked that wasn't
from you. It may have made sense to Jeff but not you - sorry

> PIO fix was directly ported from my it821x.c patch.  I now see that thanks
> to it821x_passthru_dev_select() it is not really needeed in pata_it821x.c.

I don't think its needed but if we see problems with some drive mixes its
worth further debug. One nice thing about libata is the qc interfaces
make it possibly to do clock switches very cleanly.

Alan
