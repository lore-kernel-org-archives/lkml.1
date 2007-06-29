Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbXF2SpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbXF2SpI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 14:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760754AbXF2So4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 14:44:56 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34822 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754755AbXF2Soz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 14:44:55 -0400
Date: Fri, 29 Jun 2007 19:50:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-ide@vger.kernel.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_hpt3x3: support this chip properly including
 alternative BAR layout
Message-ID: <20070629195048.02e7d18a@the-village.bc.nu>
In-Reply-To: <20070629191703.5d9cf602@the-village.bc.nu>
References: <20070629191703.5d9cf602@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jun 2007 19:17:03 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> In some cases we cannot use BAR0-BAR3 on this chip due to errata. The
> relevant interfaces are available via BAR4 and we set the chip up to use
> those instead.
> 
> This plus testing means it can move from experimental to production spec
> 
> Signed-off-by: Alan Cox <alan@redhat.com>

Argh NAK that, just when I thought it was all stable its not
