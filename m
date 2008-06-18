Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbYFRLPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbYFRLPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbYFRLPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:15:38 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:29778 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYFRLPh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:15:37 -0400
Date: Wed, 18 Jun 2008 13:15:14 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@medozas.de>, Matthew Wilcox <matthew@wil.cx>,
       linux-kernel@vger.kernel.org
Subject: Re: AZFS file system proposal
Message-ID: <20080618131514.7ea8af7e@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <alpine.LNX.1.10.0806171634040.32473@fbirervta.pbzchgretzou.qr>
References: <20080609104650.4f220492@mercedes-benz.boeblingen.de.ibm.com>
	<20080609125530.GF30405@parisc-linux.org>
	<20080610104919.504b9826@mercedes-benz.boeblingen.de.ibm.com>
	<alpine.LNX.1.10.0806110000560.20733@fbirervta.pbzchgretzou.qr>
	<20080617110655.59c915da@mercedes-benz.boeblingen.de.ibm.com>
	<alpine.LNX.1.10.0806171133220.6620@fbirervta.pbzchgretzou.qr>
	<20080617135722.374673b9@mercedes-benz.boeblingen.de.ibm.com>
	<alpine.LNX.1.10.0806171634040.32473@fbirervta.pbzchgretzou.qr>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >> (a) What is axonram?
> >> >> (b) why is axonram direct_access, and my other devices (including
> >> >> standard PC RAM) not?
> >> >
> >> >[Axonram is a module specific for IBM CellBlade and allows access to
> >> >a DDR2 memory attached onto Axon controller.] You don't need
> >> >direct_access and not azfs for main memory because there is already
> >> >a pretty nice tmpfs for it.
> >> 
> >> So the reason azfs could be useful is...?
> >
> >The "?" at the end of your sentence might mean a question. I would
> >be really happy to give an answer on it if I could understand it.
> 
> If one does not need direct_access nor azfs, and ext2 plus XIP minus
> caching or tmpfs plus XIP can achieve the same effect, what can azfs
> that we could not already do without azfs?

Our users want to have a file system with bigger block sizes (64KB, 16MB, ...). They also don't want to keep metadata on DDR2 media, but to be able to use a complete DDR2 for their applications data.

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
