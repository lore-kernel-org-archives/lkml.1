Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYJXWJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYJXWJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 18:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbYJXWJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 18:09:44 -0400
Received: from gate.crashing.org ([63.228.1.57]:45871 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755527AbYJXWJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 18:09:43 -0400
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with
	!CONFIG_BLK_DEV_IDEDMA_PMAC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       bzolnier@gmail.com
In-Reply-To: <4901BC5E.7040607@ru.mvista.com>
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au>
	 <20081024113856.GA4252@linux.vnet.ibm.com> <4901BC5E.7040607@ru.mvista.com>
Content-Type: text/plain
Date: Sat, 25 Oct 2008 09:07:42 +1100
Message-Id: <1224886062.7654.464.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 16:15 +0400, Sergei Shtylyov wrote:
> Hello.
> 
> Kamalesh Babulal wrote:
> 
> >  next-20081024 randconfig build fails on the powerpc, with
> >
> > drivers/ide/pmac.c: In function 'pmac_ide_set_pio_mode':
> > drivers/ide/pmac.c:527: error: implicit declaration of function 'kauai_lookup_timing'
> > drivers/ide/pmac.c:527: error: 'shasta_pio_timings' undeclared (first use in this function)
> > drivers/ide/pmac.c:527: error: (Each undeclared identifier is reported only once
> > drivers/ide/pmac.c:527: error: for each function it appears in.)
> > drivers/ide/pmac.c:534: error: 'kauai_pio_timings' undeclared (first use in this function)
> > drivers/ide/pmac.c: In function 'pmac_ide_do_resume':
> > drivers/ide/pmac.c:914: error: 'IDE_WAKEUP_DELAY' undeclared (first use in this function)
> > drivers/ide/pmac.c: At top level:
> > drivers/ide/pmac.c:1007: error: 'pmac_ide_init_dma' undeclared here (not in a function)
> > drivers/ide/pmac.c: In function 'pmac_ide_setup_device':
> > drivers/ide/pmac.c:1107: error: 'IDE_WAKEUP_DELAY' undeclared (first use in this function)
> > drivers/ide/pmac.c: In function 'pmac_ide_macio_attach':
> > drivers/ide/pmac.c:1209: error: 'pmac_ide_hwif_t' has no member named 'dma_regs'
> > drivers/ide/pmac.c:1210: error: 'pmac_ide_hwif_t' has no member named 'dma_regs'
> > make[2]: *** [drivers/ide/pmac.o] Error 1
> >   
> 
>    Hm, looks like this configuration was never buildable -- #ifdef's are 
> missing and wrongly placed. CCing Ben Herrenschmidt...

What configuration ?

Ben.


