Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYFQJHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYFQJHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 05:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752423AbYFQJG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 05:06:59 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:9658 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYFQJG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 05:06:58 -0400
Date: Tue, 17 Jun 2008 11:06:55 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@medozas.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
	<20080609125530.GF30405@parisc-linux.org>
	<20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com>
	<alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+config AZ_FS
> >+       tristate "AZFS filesystem support"
> 
> This is slightly redundant, it should probably be
> 	tristate "AZ filesystem support"

I have called it the same way as other file systems (in Kconfig they say "JFS filesystem support", "XFS filesystem support", "NTFS file system support", ...)

> >+       help
> >+         azfs is a file system for I/O attached memory backing. It requires
> >+         a block device with direct_access capability, e.g. axonram.
> 
> (a) What is axonram?
> (b) why is axonram direct_access, and my other devices (including
> standard PC RAM) not?

Axonram is a module specific for IBM CellBlade and allows access to a DDR2 memory attached onto Axon controller.
You don't need direct_access and not azfs for main memory because there is already a pretty nice tmpfs for it.

> >+         Mounting such device with azfs gives memory mapped access to the
> >+         underlying memory to user space.
> 
> Can't I just mmap(/dev/theblockdevice), why would I need to go through 
> azfs?

Yes, you can mmap it. But what does it have to do with a file system. I would say you can either mmap it or place a file system on it.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
