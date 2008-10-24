Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYJXMPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYJXMPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 08:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbYJXMPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 08:15:36 -0400
Received: from h155.mvista.com ([63.81.120.155]:38298 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753243AbYJXMPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 08:15:34 -0400
Message-ID: <4901BC5E.7040607@ru.mvista.com>
Date: Fri, 24 Oct 2008 16:15:26 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "benh@kernel.crashing.org" <benh@kernel.crashing.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       bzolnier@gmail.com
Subject: Re: linux-next: Tree for October 24 - powerpc - build failure with
 !CONFIG_BLK_DEV_IDEDMA_PMAC
References: <20081024171932.1e8131d0.sfr@canb.auug.org.au> <20081024113856.GA4252@linux.vnet.ibm.com>
In-Reply-To: <20081024113856.GA4252@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kamalesh Babulal wrote:

>  next-20081024 randconfig build fails on the powerpc, with
>
> drivers/ide/pmac.c: In function 'pmac_ide_set_pio_mode':
> drivers/ide/pmac.c:527: error: implicit declaration of function 'kauai_lookup_timing'
> drivers/ide/pmac.c:527: error: 'shasta_pio_timings' undeclared (first use in this function)
> drivers/ide/pmac.c:527: error: (Each undeclared identifier is reported only once
> drivers/ide/pmac.c:527: error: for each function it appears in.)
> drivers/ide/pmac.c:534: error: 'kauai_pio_timings' undeclared (first use in this function)
> drivers/ide/pmac.c: In function 'pmac_ide_do_resume':
> drivers/ide/pmac.c:914: error: 'IDE_WAKEUP_DELAY' undeclared (first use in this function)
> drivers/ide/pmac.c: At top level:
> drivers/ide/pmac.c:1007: error: 'pmac_ide_init_dma' undeclared here (not in a function)
> drivers/ide/pmac.c: In function 'pmac_ide_setup_device':
> drivers/ide/pmac.c:1107: error: 'IDE_WAKEUP_DELAY' undeclared (first use in this function)
> drivers/ide/pmac.c: In function 'pmac_ide_macio_attach':
> drivers/ide/pmac.c:1209: error: 'pmac_ide_hwif_t' has no member named 'dma_regs'
> drivers/ide/pmac.c:1210: error: 'pmac_ide_hwif_t' has no member named 'dma_regs'
> make[2]: *** [drivers/ide/pmac.o] Error 1
>   

   Hm, looks like this configuration was never buildable -- #ifdef's are 
missing and wrongly placed. CCing Ben Herrenschmidt...

MBR, Sergei


