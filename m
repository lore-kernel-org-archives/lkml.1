Return-Path: <linux-kernel-owner+w=401wt.eu-S1162217AbXECSKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162217AbXECSKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162218AbXECSKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:10:05 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37152 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162217AbXECSKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:10:04 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 14:09:13 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: linux-pcmcia@lists.infradead.org
Subject: dead CONFIG_ variables under drivers/pcmcia
Message-ID: <Pine.LNX.4.64.0705031407180.11929@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


$ ../dead_config.sh drivers/pcmcia
========== M32RPCC_SLOT2 ==========
drivers/pcmcia/m32r_pcc.c:710:#ifdef CONFIG_M32RPCC_SLOT2
========== MPC860T ==========
drivers/pcmcia/m8xx_pcmcia.c:95:#if defined(CONFIG_MPC860T) || defined(CONFIG_MPC860) || defined(CONFIG_MPC821)
arch/ppc/8xx_io/fec.c:7: * for the control of the LevelOne LXT970 transceiver.  The MPC860T manual
drivers/net/fec.c:7: * for the control of the LevelOne LXT970 transceiver.  The MPC860T manual
drivers/net/fec.c:1791: *       Code specific to the MPC860T setup.
include/asm-ppc/8xx_immap.h:388:/* MPC860T Fast Ethernet Controller.  It isn't part of the CPM, but
========== PCMCIA_SLOT_A ==========
drivers/pcmcia/m8xx_pcmcia.c:79:#if !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B)
drivers/pcmcia/m8xx_pcmcia.c:89:#define CONFIG_PCMCIA_SLOT_A
drivers/pcmcia/m8xx_pcmcia.c:96:#define CONFIG_PCMCIA_SLOT_A
drivers/pcmcia/m8xx_pcmcia.c:103:#define CONFIG_PCMCIA_SLOT_A
drivers/pcmcia/m8xx_pcmcia.c:109:#define CONFIG_PCMCIA_SLOT_A
drivers/pcmcia/m8xx_pcmcia.c:113:#endif /* !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B) */
drivers/pcmcia/m8xx_pcmcia.c:115:#if defined(CONFIG_PCMCIA_SLOT_A) && defined(CONFIG_PCMCIA_SLOT_B)
drivers/pcmcia/m8xx_pcmcia.c:123:#elif defined(CONFIG_PCMCIA_SLOT_A) || defined(CONFIG_PCMCIA_SLOT_B)
drivers/pcmcia/m8xx_pcmcia.c:132:#ifdef CONFIG_PCMCIA_SLOT_A
========== PCMCIA_SLOT_B ==========
drivers/pcmcia/m8xx_pcmcia.c:79:#if !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B)
drivers/pcmcia/m8xx_pcmcia.c:83:#define CONFIG_PCMCIA_SLOT_B
drivers/pcmcia/m8xx_pcmcia.c:98:#define CONFIG_PCMCIA_SLOT_B
drivers/pcmcia/m8xx_pcmcia.c:110:#define CONFIG_PCMCIA_SLOT_B
drivers/pcmcia/m8xx_pcmcia.c:113:#endif /* !defined(CONFIG_PCMCIA_SLOT_A) && !defined(CONFIG_PCMCIA_SLOT_B) */
drivers/pcmcia/m8xx_pcmcia.c:115:#if defined(CONFIG_PCMCIA_SLOT_A) && defined(CONFIG_PCMCIA_SLOT_B)
drivers/pcmcia/m8xx_pcmcia.c:123:#elif defined(CONFIG_PCMCIA_SLOT_A) || defined(CONFIG_PCMCIA_SLOT_B)
========== PRxK ==========
drivers/pcmcia/m8xx_pcmcia.c:108:#ifdef CONFIG_PRxK
drivers/pcmcia/m8xx_pcmcia.c:545:#if defined(CONFIG_PRxK)
drivers/pcmcia/m8xx_pcmcia.c:605:#endif /* CONFIG_PRxK */

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
