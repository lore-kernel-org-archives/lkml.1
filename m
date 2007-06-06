Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbXFFQaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbXFFQaZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753808AbXFFQaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 12:30:07 -0400
Received: from [81.2.110.250] ([81.2.110.250]:39669 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758962AbXFFQaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 12:30:06 -0400
Date: Wed, 6 Jun 2007 17:34:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Mikael Pettersson <mikpe@it.uu.se>,
       akpm@linux-foundation.org, david@dgreaves.com,
       jean.luc.coulon@gmail.com, jgarzik@pobox.com,
       michal.k.k.piotrowski@gmail.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling
 NODATA commands
Message-ID: <20070606173452.27e0a0c3@the-village.bc.nu>
In-Reply-To: <20070606160511.GA23143@havoc.gtf.org>
References: <200706052131.l55LVkYN000191@harpo.it.uu.se>
	<20070605215256.GT31565@havoc.gtf.org>
	<46665AB5.6040508@gmail.com>
	<20070606102122.GD29122@htj.dyndns.org>
	<20070606160511.GA23143@havoc.gtf.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 12:05:11 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> 
> FYI to all -- 
> 
> As a reminder. the Promise hardware programs registers when it receives
> a SET FEATURES - XFER MODE.
> 
> If data transfer is occurring on OTHER ports at the time this is issued,
> then data corruption is guaranteed to occur.  Polling will not fix this
> problem -- all ports need to be inactive, when a SET FEATURES - XFER
> MODE command is issued for any port.

Cool - will whoever makes that work drop me a note as I need to do the
same eventually for a couple of other controllers.
