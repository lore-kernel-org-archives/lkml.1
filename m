Return-Path: <linux-kernel-owner+w=401wt.eu-S1759177AbYE2S5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177AbYE2S5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758739AbYE2S5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:57:09 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40552 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758458AbYE2S5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:57:08 -0400
Date: Thu, 29 May 2008 19:42:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: RESEND: [PATCH] libata-sff: Fix oops reported in kerneloops.org
 for pnp devices with no ctl
Message-ID: <20080529194238.36458a46@core>
In-Reply-To: <483EF536.90801@garzik.org>
References: <20080529161453.24735.805.stgit@core>
	<alpine.LFD.1.10.0805290950230.2958@woody.linux-foundation.org>
	<20080529190235.258d304e@core>
	<483EF536.90801@garzik.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please grep the remaining users, IMO you will find that's not really 
> true.  After your patch no core users remain, only ones in a few 
> scattered drivers that most likely want your logic (or a 
> simplified-for-that-controller version thereof).

That said if you want to be clearer we can hide the altstatus function
internally and only export an ata_sff_dma_sync() which does go *BANG* if
you call it with no altstatus (where you would immediately violate DMA
timing rules)

Want me to roll a patch in that style ?

Alan
