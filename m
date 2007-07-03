Return-Path: <linux-kernel-owner+w=401wt.eu-S1760635AbXGCPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760635AbXGCPne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758280AbXGCPnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:43:16 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42034 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757468AbXGCPnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:43:14 -0400
Date: Tue, 3 Jul 2007 16:49:27 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_hpt3x3: Major reworking and testing
Message-ID: <20070703164927.78596662@the-village.bc.nu>
In-Reply-To: <468A6DDB.706@garzik.org>
References: <20070703161002.1576c39d@the-village.bc.nu>
	<468A6DDB.706@garzik.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jul 2007 11:40:11 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Alan Cox wrote:
> > The HPT343/345 (aka 363) is a bit of a warped device. For many setups you
> > need to access the other registers via BAR4 offsets. PIO is now rock
> > solid, DMA isn't. Unfortunately the drivers/ide hpt34x driver is
> > completely broken so doesn't help further debug.
> > 
> > Signed-off-by: Alan Cox <alan@redhat.com>
> 
> OK but doesn't apply

All the patches to Andrew cc you are versus -mm tree for Andrew so they
can get tested. I'll feed you patches versus the base Linus tree at some
point in the future when I have time to resync them (probably a couple of
weeks) which should be about right for them having been tested well.

Alan
