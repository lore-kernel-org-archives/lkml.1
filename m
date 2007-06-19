Return-Path: <linux-kernel-owner+w=401wt.eu-S1759492AbXFSQTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbXFSQTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 12:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755184AbXFSQTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 12:19:08 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:36366 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754802AbXFSQTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 12:19:06 -0400
Date: Tue, 19 Jun 2007 17:17:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Lord <lkml@rtr.ca>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Linas Vepstas <linas@austin.ibm.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070619171745.7c2240bf@the-village.bc.nu>
In-Reply-To: <4677F881.6060200@rtr.ca>
References: <20070618175713.GD5836@austin.ibm.com>
	<20070618212704.394912b8@the-village.bc.nu>
	<20070618204601.GF5836@austin.ibm.com>
	<20070618220441.3a3af8ca@the-village.bc.nu>
	<4677E3BC.3040307@ru.mvista.com>
	<20070619151919.79c79af1@the-village.bc.nu>
	<4677E726.1080602@ru.mvista.com>
	<4677F881.6060200@rtr.ca>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >    Indeed... but the thing is we don't know what's asserted in this case 
> > -- remember, it's reading the status register that locks everything up...
> 
> Exactly.  And IORDY shouldn't really apply there,
> unless some nitwit standards person wrote it into a spec..

Could it be we need to reset the state machine at this point before we
touch the registers again - that wouldn't be the first controller with
this limit and undocumented.

On the 370 we already 

Linas; For the debug on the libata one turn on ATA_DEBUG and
ATA_VERBOSE_DEBUG in include/linux/libata.h and it should spew
diagnostics before the freeze. I suspect thats a different problem to the
hang you see now but I'd like to debug both.

Alan
