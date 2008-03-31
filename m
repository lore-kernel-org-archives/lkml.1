Return-Path: <linux-kernel-owner+w=401wt.eu-S1756895AbYCaNRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbYCaNRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 09:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbYCaNRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 09:17:20 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:60013 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530AbYCaNRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 09:17:17 -0400
Message-ID: <47F0E456.5080201@linux.vnet.ibm.com>
Date: Mon, 31 Mar 2008 18:47:10 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: [BUILD_FAILURE] linux-next: Tree for March 31 build fails with CONFIG_SLICOSS=y
References: <20080331181118.7964d4a9.sfr@canb.auug.org.au>
In-Reply-To: <20080331181118.7964d4a9.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

The kernel next-20080331 kernel build fails with Alacritech's IS-NIC gigabit ethernet
driver on powerpc with allyesconfig (with # CONFIG_NOVFS is not set)

  CC      drivers/net/slicoss/slicoss.o
drivers/net/slicoss/slicoss.c: In function ‘slic_xmit_build_request’:
drivers/net/slicoss/slicoss.c:933: error: ‘Stop’ undeclared (first use in this function)
drivers/net/slicoss/slicoss.c:933: error: (Each undeclared identifier is reported only once
drivers/net/slicoss/slicoss.c:933: error: for each function it appears in.)
drivers/net/slicoss/slicoss.c:933: error: expected ‘;’ before ‘Compilation’
drivers/net/slicoss/slicoss.c: In function ‘slic_link_event_handler’:
drivers/net/slicoss/slicoss.c:1420: error: ‘Stop’ undeclared (first use in this function)
drivers/net/slicoss/slicoss.c:1420: error: expected ‘;’ before ‘compilation’
drivers/net/slicoss/slicoss.c: In function ‘slic_if_init’:
drivers/net/slicoss/slicoss.c:1848: error: ‘Stop’ undeclared (first use in this function)
drivers/net/slicoss/slicoss.c:1848: error: expected ‘;’ before ‘Compilations’
drivers/net/slicoss/slicoss.c: In function ‘slic_card_init’:
drivers/net/slicoss/slicoss.c:2518: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_timer_get_stats’:
drivers/net/slicoss/slicoss.c:3269: error: ‘Stop’ undeclared (first use in this function)
drivers/net/slicoss/slicoss.c:3269: error: expected ‘;’ before ‘compilation’
drivers/net/slicoss/slicoss.c: In function ‘slic_link_upr_complete’:
drivers/net/slicoss/slicoss.c:3683: error: ‘Stop’ undeclared (first use in this function)
drivers/net/slicoss/slicoss.c:3683: error: expected ‘;’ before ‘Compilation’
drivers/net/slicoss/slicoss.c: In function ‘slic_eeprom_cksum’:
drivers/net/slicoss/slicoss.c:3806: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_rspqueue_init’:
drivers/net/slicoss/slicoss.c:3901: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:3901: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_rspqueue_getnext’:
drivers/net/slicoss/slicoss.c:3990: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:3990: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4004: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4004: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4009: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4009: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_cmdqmem_addpage’:
drivers/net/slicoss/slicoss.c:4056: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4056: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_cmdq_init’:
drivers/net/slicoss/slicoss.c:4081: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4081: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_cmdq_addcmdpage’:
drivers/net/slicoss/slicoss.c:4184: error: implicit declaration of function ‘virt_to_bus’
drivers/net/slicoss/slicoss.c:4224: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4224: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4230: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4230: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_cmdq_getdone’:
drivers/net/slicoss/slicoss.c:4271: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4271: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_cmdq_putdone’:
drivers/net/slicoss/slicoss.c:4287: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4287: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4289: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4289: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_cmdq_putdone_irq’:
drivers/net/slicoss/slicoss.c:4301: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4301: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4303: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c:4303: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_rcvqueue_fill’:
drivers/net/slicoss/slicoss.c:4425: warning: cast from pointer to integer of different size
drivers/net/slicoss/slicoss.c: In function ‘slic_rcvqueue_reinsert’:
drivers/net/slicoss/slicoss.c:4504: warning: cast from pointer to integer of different size
make[3]: *** [drivers/net/slicoss/slicoss.o] Error 1
make[2]: *** [drivers/net/slicoss] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2



-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
