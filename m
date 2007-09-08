Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbXIHSgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbXIHSgV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 14:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbXIHSgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 14:36:14 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46968 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754188AbXIHSgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 14:36:13 -0400
Date: Sat, 8 Sep 2007 19:44:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Chinner <dgc@sgi.com>, n <xellos@bluebottle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: limiting to UDMA/33 instead of UDMA/100 - pata_pdc202xx_old
 (also XFS error)?
Message-ID: <20070908194406.68b10855@the-village.bc.nu>
In-Reply-To: <46E1E2F6.5060307@garzik.org>
References: <007d01c7eaf6$74b9b350$0100a8c0@hak>
	<20070907130212.GI995458@sgi.com>
	<46E1E2F6.5060307@garzik.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Sep 2007 19:47:02 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> >>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> >>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> >>         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> 
> 
> ATA bus error == straight-from-hardware reported error
> 
> Cable or connector is dying maybe?  Bad power supplies also sometimes 
> manifest this way.

With PATA some kind of misclocking can occassionally produce similar
results so its worth a bit of driver debug as well - especially if
forcing the speed down a little helps.
