Return-Path: <linux-kernel-owner+w=401wt.eu-S1759048AbXFUVgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbXFUVgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 17:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756206AbXFUVgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 17:36:00 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55220 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755140AbXFUVf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 17:35:58 -0400
Date: Thu, 21 Jun 2007 22:41:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Linas Vepstas <linas@austin.ibm.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Stuart_Hayes@dell.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] ide dma_timer_expiry, then hard lockup
Message-ID: <20070621224102.1ae04397@the-village.bc.nu>
In-Reply-To: <467ABC4D.5010004@ru.mvista.com>
References: <20070618175713.GD5836@austin.ibm.com>
	<4677FFF1.2010308@ru.mvista.com>
	<20070619164854.GR5836@austin.ibm.com>
	<200706192043.40298.bzolnier@gmail.com>
	<46783777.10607@ru.mvista.com>
	<20070620162845.GY5836@austin.ibm.com>
	<20070620180123.642316ae@the-village.bc.nu>
	<467ABC4D.5010004@ru.mvista.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > queue ? You are overestimating IDE ;)
> 
>     He's not -- there is queued commands support since ATA[PI]-5. I'm not sure 
> why but Linux decided not to support it.

Almost no hardware supports it and the functionality is really really
ugly to use when it works at all - NCQ is rather more elegant.

Alan
