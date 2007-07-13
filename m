Return-Path: <linux-kernel-owner+w=401wt.eu-S936088AbXGMOca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936088AbXGMOca (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:32:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935728AbXGMOcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:32:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47964 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935646AbXGMOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:32:10 -0400
Subject: Re: [Resend][Patch] drivers/mtd/maps/tqm8xxl.c: Do some cleanups
From: David Woodhouse <dwmw2@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>, kirk@hpc.ee.ntu.edu.tw,
       akpm@osdl.org, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070713142442.GA8190@linux-mips.org>
References: <20070712150135.GA4102@localhost.localdomain>
	 <1184256718.32199.111.camel@weaponx.rchland.ibm.com>
	 <20070713034822.GA2370@localhost.localdomain>
	 <1184320602.2785.18.camel@shinybook.infradead.org>
	 <20070713131458.GA1997@localhost.localdomain>
	 <1184333884.8809.5.camel@hades.cambridge.redhat.com>
	 <20070713142442.GA8190@linux-mips.org>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 15:31:29 +0100
Message-Id: <1184337089.8809.11.camel@hades.cambridge.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-07-13 at 15:24 +0100, Ralf Baechle wrote:
> +config MTD_PMC_MSP_EVM
> +       tristate "CFI Flash device mapped on PMC-Sierra MSP"
> +       depends on PMC_MSP && MTD_CFI
> +       select MTD_PARTITIONS
> 
> drivers/mtd/maps/Makefile:obj-$(CONFIG_MTD_PMC_MSP_EVM)   +=
> pmcmsp-flash.o
> 
> Is he trying to build something else than very recent kernel.org
> tree? 

Hm. His mail did say "Even when I use `make allyesconfig`, I still can't
compile some drivers. I should add the corresponding CONFIGs manually."
          
I wonder if he disabled the correct conditions and then tried building
it in an i386 kernel?

-- 
dwmw2

