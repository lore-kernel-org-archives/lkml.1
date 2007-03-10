Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXCJWHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXCJWHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 17:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXCJWHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 17:07:01 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:50407 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXCJWG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 17:06:59 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 17:03:57 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove unused header file.
Message-ID: <Pine.LNX.4.64.0703101701330.28511@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.432, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, UPPERCASE_50_75 0.37)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Remove apparently unused header file
drivers/net/chelsio/vsc8244_reg.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  not sure who the maintainer is here.

diff --git a/drivers/net/chelsio/vsc8244_reg.h b/drivers/net/chelsio/vsc8244_reg.h
deleted file mode 100644
index d3c1829..0000000
--- a/drivers/net/chelsio/vsc8244_reg.h
+++ /dev/null
@@ -1,172 +0,0 @@
-/* $Date: 2005/11/23 16:28:53 $ $RCSfile: vsc8244_reg.h,v $ $Revision: 1.1 $ */
-#ifndef CHELSIO_MV8E1XXX_H
-#define CHELSIO_MV8E1XXX_H
-
-#ifndef BMCR_SPEED1000
-# define BMCR_SPEED1000 0x40
-#endif
-
-#ifndef ADVERTISE_PAUSE
-# define ADVERTISE_PAUSE 0x400
-#endif
-#ifndef ADVERTISE_PAUSE_ASYM
-# define ADVERTISE_PAUSE_ASYM 0x800
-#endif
-
-/* Gigabit MII registers */
-#define MII_GBMR 1       /* 1000Base-T mode register */
-#define MII_GBCR 9       /* 1000Base-T control register */
-#define MII_GBSR 10      /* 1000Base-T status register */
-
-/* 1000Base-T control register fields */
-#define GBCR_ADV_1000HALF         0x100
-#define GBCR_ADV_1000FULL         0x200
-#define GBCR_PREFER_MASTER        0x400
-#define GBCR_MANUAL_AS_MASTER     0x800
-#define GBCR_MANUAL_CONFIG_ENABLE 0x1000
-
-/* 1000Base-T status register fields */
-#define GBSR_LP_1000HALF  0x400
-#define GBSR_LP_1000FULL  0x800
-#define GBSR_REMOTE_OK    0x1000
-#define GBSR_LOCAL_OK     0x2000
-#define GBSR_LOCAL_MASTER 0x4000
-#define GBSR_MASTER_FAULT 0x8000
-
-/* Vitesse PHY interrupt status bits. */
-#if 0
-#define VSC8244_INTR_JABBER          0x0001
-#define VSC8244_INTR_POLARITY_CHNG   0x0002
-#define VSC8244_INTR_ENG_DETECT_CHNG 0x0010
-#define VSC8244_INTR_DOWNSHIFT       0x0020
-#define VSC8244_INTR_MDI_XOVER_CHNG  0x0040
-#define VSC8244_INTR_FIFO_OVER_UNDER 0x0080
-#define VSC8244_INTR_FALSE_CARRIER   0x0100
-#define VSC8244_INTR_SYMBOL_ERROR    0x0200
-#define VSC8244_INTR_LINK_CHNG       0x0400
-#define VSC8244_INTR_AUTONEG_DONE    0x0800
-#define VSC8244_INTR_PAGE_RECV       0x1000
-#define VSC8244_INTR_DUPLEX_CHNG     0x2000
-#define VSC8244_INTR_SPEED_CHNG      0x4000
-#define VSC8244_INTR_AUTONEG_ERR     0x8000
-#else
-//#define VSC8244_INTR_JABBER          0x0001
-//#define VSC8244_INTR_POLARITY_CHNG   0x0002
-//#define VSC8244_INTR_BIT2            0x0004
-//#define VSC8244_INTR_BIT3            0x0008
-#define VSC8244_INTR_RX_ERR          0x0001
-#define VSC8244_INTR_MASTER_SLAVE    0x0002
-#define VSC8244_INTR_CABLE_IMPAIRED  0x0004
-#define VSC8244_INTR_FALSE_CARRIER   0x0008
-//#define VSC8244_INTR_ENG_DETECT_CHNG 0x0010
-//#define VSC8244_INTR_DOWNSHIFT       0x0020
-//#define VSC8244_INTR_MDI_XOVER_CHNG  0x0040
-//#define VSC8244_INTR_FIFO_OVER_UNDER 0x0080
-#define VSC8244_INTR_BIT4            0x0010
-#define VSC8244_INTR_FIFO_RX         0x0020
-#define VSC8244_INTR_FIFO_OVER_UNDER 0x0040
-#define VSC8244_INTR_LOCK_LOST       0x0080
-//#define VSC8244_INTR_FALSE_CARRIER   0x0100
-//#define VSC8244_INTR_SYMBOL_ERROR    0x0200
-//#define VSC8244_INTR_LINK_CHNG       0x0400
-//#define VSC8244_INTR_AUTONEG_DONE    0x0800
-#define VSC8244_INTR_SYMBOL_ERROR    0x0100
-#define VSC8244_INTR_ENG_DETECT_CHNG 0x0200
-#define VSC8244_INTR_AUTONEG_DONE    0x0400
-#define VSC8244_INTR_AUTONEG_ERR     0x0800
-//#define VSC8244_INTR_PAGE_RECV       0x1000
-//#define VSC8244_INTR_DUPLEX_CHNG     0x2000
-//#define VSC8244_INTR_SPEED_CHNG      0x4000
-//#define VSC8244_INTR_AUTONEG_ERR     0x8000
-#define VSC8244_INTR_DUPLEX_CHNG     0x1000
-#define VSC8244_INTR_LINK_CHNG       0x2000
-#define VSC8244_INTR_SPEED_CHNG      0x4000
-#define VSC8244_INTR_STATUS          0x8000
-#endif
-
-
-/* Vitesse PHY specific registers. */
-#define VSC8244_SPECIFIC_CNTRL_REGISTER               16
-#define VSC8244_SPECIFIC_STATUS_REGISTER              0x1c
-#define VSC8244_INTERRUPT_ENABLE_REGISTER             0x19
-#define VSC8244_INTERRUPT_STATUS_REGISTER             0x1a
-#define VSC8244_EXT_PHY_SPECIFIC_CNTRL_REGISTER       20
-#define VSC8244_RECV_ERR_CNTR_REGISTER                21
-#define VSC8244_RES_REGISTER                          22
-#define VSC8244_GLOBAL_STATUS_REGISTER                23
-#define VSC8244_LED_CONTROL_REGISTER                  24
-#define VSC8244_MANUAL_LED_OVERRIDE_REGISTER          25
-#define VSC8244_EXT_PHY_SPECIFIC_CNTRL_2_REGISTER     26
-#define VSC8244_EXT_PHY_SPECIFIC_STATUS_REGISTER      27
-#define VSC8244_VIRTUAL_CABLE_TESTER_REGISTER         28
-#define VSC8244_EXTENDED_ADDR_REGISTER                29
-#define VSC8244_EXTENDED_REGISTER                     30
-
-/* PHY specific control register fields */
-#define S_PSCR_MDI_XOVER_MODE    5
-#define M_PSCR_MDI_XOVER_MODE    0x3
-#define V_PSCR_MDI_XOVER_MODE(x) ((x) << S_PSCR_MDI_XOVER_MODE)
-#define G_PSCR_MDI_XOVER_MODE(x) (((x) >> S_PSCR_MDI_XOVER_MODE) & M_PSCR_MDI_XOVER_MODE)
-
-/* Extended PHY specific control register fields */
-#define S_DOWNSHIFT_ENABLE 8
-#define V_DOWNSHIFT_ENABLE (1 << S_DOWNSHIFT_ENABLE)
-
-#define S_DOWNSHIFT_CNT    9
-#define M_DOWNSHIFT_CNT    0x7
-#define V_DOWNSHIFT_CNT(x) ((x) << S_DOWNSHIFT_CNT)
-#define G_DOWNSHIFT_CNT(x) (((x) >> S_DOWNSHIFT_CNT) & M_DOWNSHIFT_CNT)
-
-/* PHY specific status register fields */
-#define S_PSSR_JABBER 0
-#define V_PSSR_JABBER (1 << S_PSSR_JABBER)
-
-#define S_PSSR_POLARITY 1
-#define V_PSSR_POLARITY (1 << S_PSSR_POLARITY)
-
-#define S_PSSR_RX_PAUSE 2
-#define V_PSSR_RX_PAUSE (1 << S_PSSR_RX_PAUSE)
-
-#define S_PSSR_TX_PAUSE 3
-#define V_PSSR_TX_PAUSE (1 << S_PSSR_TX_PAUSE)
-
-#define S_PSSR_ENERGY_DETECT 4
-#define V_PSSR_ENERGY_DETECT (1 << S_PSSR_ENERGY_DETECT)
-
-#define S_PSSR_DOWNSHIFT_STATUS 5
-#define V_PSSR_DOWNSHIFT_STATUS (1 << S_PSSR_DOWNSHIFT_STATUS)
-
-#define S_PSSR_MDI 6
-#define V_PSSR_MDI (1 << S_PSSR_MDI)
-
-#define S_PSSR_CABLE_LEN    7
-#define M_PSSR_CABLE_LEN    0x7
-#define V_PSSR_CABLE_LEN(x) ((x) << S_PSSR_CABLE_LEN)
-#define G_PSSR_CABLE_LEN(x) (((x) >> S_PSSR_CABLE_LEN) & M_PSSR_CABLE_LEN)
-
-//#define S_PSSR_LINK 10
-//#define S_PSSR_LINK 13
-#define S_PSSR_LINK 2
-#define V_PSSR_LINK (1 << S_PSSR_LINK)
-
-//#define S_PSSR_STATUS_RESOLVED 11
-//#define S_PSSR_STATUS_RESOLVED 10
-#define S_PSSR_STATUS_RESOLVED 15
-#define V_PSSR_STATUS_RESOLVED (1 << S_PSSR_STATUS_RESOLVED)
-
-#define S_PSSR_PAGE_RECEIVED 12
-#define V_PSSR_PAGE_RECEIVED (1 << S_PSSR_PAGE_RECEIVED)
-
-//#define S_PSSR_DUPLEX 13
-//#define S_PSSR_DUPLEX 12
-#define S_PSSR_DUPLEX 5
-#define V_PSSR_DUPLEX (1 << S_PSSR_DUPLEX)
-
-//#define S_PSSR_SPEED    14
-//#define S_PSSR_SPEED    14
-#define S_PSSR_SPEED    3
-#define M_PSSR_SPEED    0x3
-#define V_PSSR_SPEED(x) ((x) << S_PSSR_SPEED)
-#define G_PSSR_SPEED(x) (((x) >> S_PSSR_SPEED) & M_PSSR_SPEED)
-
-#endif
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
