Return-Path: <linux-kernel-owner+w=401wt.eu-S933201AbXGMOY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933201AbXGMOY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbXGMOYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:24:51 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:53512 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452AbXGMOYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:24:50 -0400
Date: Fri, 13 Jul 2007 15:24:43 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
Message-ID: <20070713142442.GA8190@linux-mips.org>
References: <20070712150135.GA4102@localhost.localdomain> <1184256718.32199.111.camel@weaponx.rchland.ibm.com> <20070713034822.GA2370@localhost.localdomain> <1184320602.2785.18.camel@shinybook.infradead.org> <20070713131458.GA1997@localhost.localdomain> <1184333884.8809.5.camel@hades.cambridge.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184333884.8809.5.camel@hades.cambridge.redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 02:38:03PM +0100, David Woodhouse wrote:

> > drivers/mtd/maps/pmcmsp-flash.c:63: error: 'ELB_1PC_EN_REG' undeclared (first use in this function)
> > drivers/mtd/maps/pmcmsp-flash.c:63: error: 'SINGLE_PCCARD' undeclared (first use in this function)
> > 
> > Did I miss something?
> 
> I think that map driver should probably depend on CONFIG_PMC_MSP. Ralf?

*confused*

68aa0fa87f6d4b2f5e8ad39ecaec8bba9137bb3d did add:

+config MTD_PMC_MSP_EVM
+       tristate "CFI Flash device mapped on PMC-Sierra MSP"
+       depends on PMC_MSP && MTD_CFI
+       select MTD_PARTITIONS

drivers/mtd/maps/Makefile:obj-$(CONFIG_MTD_PMC_MSP_EVM)   += pmcmsp-flash.o

Is he trying to build something else than very recent kernel.org tree?

  Ralf
