Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYDQOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYDQOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbYDQOoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 10:44:07 -0400
Received: from [85.114.38.90] ([85.114.38.90]:55384 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756293AbYDQOoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 10:44:06 -0400
Date: Thu, 17 Apr 2008 15:16:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Madore <david.madore@ens.fr>
Cc: Linux Kernel Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: does pata_marvell (88SE6145 driver) support external SATA port?
Message-ID: <20080417151622.1da00713@the-village.bc.nu>
In-Reply-To: <20080417121238.GA29263@clipper.ens.fr>
References: <20080417121238.GA29263@clipper.ens.fr>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does the pata_marvell module support an external SATA port?

pata_marvell supports the PATA port on some Marvell devices. The SATA
side is supported by other drivers depending on the chip.

> How can I know this without buying an external SATA drive and
> discovering to my dismay that I can't use it? :-)

Software side most ESATA looks identical to SATA but some cheap stuff
just puts internal SATA on an ESATA connector Be wary of that.

Alan
