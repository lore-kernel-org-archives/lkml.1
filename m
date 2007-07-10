Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbXGJQxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbXGJQxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 12:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754714AbXGJQxE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 12:53:04 -0400
Received: from mail.karo-electronics.de ([213.146.116.110]:40448 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbXGJQxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 12:53:03 -0400
X-Greylist: delayed 2153 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 12:53:03 EDT
Message-ID: <18067.45288.808891.13294@ipc1.karo>
Date: Tue, 10 Jul 2007 18:16:40 +0200
From: "Lothar Wassmann" <LW@KARO-electronics.de>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Li Yang-r58472 <LeoLi@freescale.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PXA27x UDC driver.
In-Reply-To: <20070710154935.GA3445@enneenne.com>
References: <20070628103619.GW13886@enneenne.com>
	<989B956029373F45A0B8AF0297081890D834FA@zch01exm26.fsl.freescale.net>
	<20070628141205.GA13886@enneenne.com>
	<20070628142949.02ca9eab.akpm@linux-foundation.org>
	<20070710154935.GA3445@enneenne.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> > > +static int
> > > +write_packet(volatile u32 * uddr, struct pxa27x_request *req, unsigned max)
> > 
> > Please review Documentation/volatile-considered-harmful.txt
> 
> The attibute volatile here is necessary in order to avoid getting the
> following warnings from the compiler:
> 
[...]
> 
> Do you know how I can resolve this?
> 
ioremap() the memory area for the UDC registers and use an __iomem
cookie.


Lothar Wassmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen, Rolf Rosenstein
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
