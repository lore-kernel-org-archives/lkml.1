Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYGIK66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYGIK66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 06:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbYGIK6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 06:58:49 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:16881 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYGIK6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 06:58:48 -0400
Date: Wed, 9 Jul 2008 12:58:48 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: AZFS file system proposal
Message-ID: <20080709125848.643008a3@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <1215595414.8970.366.camel@pasglop>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	<200807011659.33413.arnd@arndb.de>
	<1215593918.8970.363.camel@pasglop>
	<20080709111402.5af92580@mercedes-benz.boeblingen.de.ibm.com>
	<1215595414.8970.366.camel@pasglop>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd rather do
> 
> 	pgprot_t  prot;
> 
> #ifdef CONFIG_PPC
> 	prot = <whatever>
> #else
> 	prot = pgprot_noncached(...)
> #endif
> 	vma->vm_page_prot = prot;

I have changed my patch accordinly. Thank you.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Research & Development GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Martin Jetter
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
