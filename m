Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXECSP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXECSP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 14:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754787AbXECSP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 14:15:29 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:37365 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbXECSP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 14:15:28 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 14:15:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: dead CONFIG_ variables under drivers/serial/
Message-ID: <Pine.LNX.4.64.0705031410550.11929@localhost.localdomain>
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


  this one's a biggie, with a few obvious false positives.


$ ../dead_config.sh drivers/serial
========== 68328_SERIAL_UART2 ==========
drivers/serial/68328serial.h:184:#ifndef CONFIG_68328_SERIAL_UART2
========== ALMA_ANS ==========
drivers/serial/68328serial.c:109:#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
========== CONSOLE ==========
drivers/serial/68328serial.c:82:#ifdef CONFIG_CONSOLE
drivers/serial/68328serial.c:309:#ifdef CONFIG_CONSOLE
arch/m68k/kernel/head.S:156: * #ifdef CONSOLE/#endif clauses so it doesn't have to ship in known-good
arch/m68k/kernel/head.S:201: * CONSOLE: There is support for head.S console in this file.  This
arch/m68k/kernel/head.S:276:#define CONSOLE
arch/m68k/kernel/head.S:493:#if defined(CONSOLE) || defined(SERIAL_DEBUG)
arch/m68k/kernel/head.S:496:#ifdef CONSOLE
arch/m68k/kernel/head.S:502:#if defined(CONSOLE) || defined(SERIAL_DEBUG)
arch/m68k/kernel/head.S:522:#if defined(CONSOLE) || defined(SERIAL_DEBUG)
arch/m68k/kernel/head.S:913:#ifdef CONSOLE
arch/m68k/kernel/head.S:919:#endif      /* CONSOLE */
arch/m68k/kernel/head.S:1424:#if defined(CONSOLE)
arch/m68k/kernel/head.S:3210:#ifdef CONSOLE
arch/m68k/kernel/head.S:3239:#ifdef CONSOLE
arch/m68k/kernel/head.S:3301:#ifdef CONSOLE
arch/m68k/kernel/head.S:3782:#endif /* CONSOLE */
arch/m68k/kernel/head.S:3827:#if defined(CONSOLE)
arch/m68k/kernel/head.S:3839:#endif /* CONSOLE */
arch/alpha/kernel/err_common.c:248:     printk("%s******* CONSOLE DATA LOG FOR CPU %d. *******\n"
arch/alpha/kernel/err_common.c:259:              "**** END OF CONSOLE DATA LOG FOR CPU %d ****\n",
arch/s390/kernel/setup.c:238:           cpcmd("QUERY CONSOLE", query_buffer, 1024, NULL);
Documentation/ia64/serial.txt:43:CONSOLE SELECTION
Documentation/ia64/serial.txt:70:EARLY SERIAL CONSOLE
Documentation/ia64/serial.txt:83:TROUBLESHOOTING SERIAL CONSOLE PROBLEMS
Documentation/sh/kgdb.txt:160:NOTE: TO AVOID LOSSING CONSOLE MESSAGES IN CASE THE KERNEL CONSOLE AND
Documentation/s390/config3270.sh:59:    elif [ $maj = CONSOLE ]; then
include/asm-sh/snapgear.h:58: * D4         ttySC0 DCD (7100)      CONSOLE
include/linux/fb.h:515:/*      CONSOLE-SPECIFIC: get console to framebuffer mapping */
include/linux/fb.h:517:/*      CONSOLE-SPECIFIC: set console to framebuffer mapping */
MAINTAINERS:3028:SGI SN-IA64 (Altix) SERIAL CONSOLE DRIVER
========== CONSOLE_115200 ==========
drivers/serial/68360serial.c:309:#elif defined(CONFIG_CONSOLE_115200)
========== CONSOLE_19200 ==========
drivers/serial/68360serial.c:307:#elif defined(CONFIG_CONSOLE_19200)
========== CONSOLE_9600 ==========
drivers/serial/68360serial.c:305:#if defined(CONFIG_CONSOLE_9600)
========== CPU_S3C2413 ==========
drivers/serial/s3c2410.c:1530:#if defined(CONFIG_CPU_S3C2412) || defined(CONFIG_CPU_S3C2413)
========== DRAGONIXVZ ==========
drivers/serial/68328serial.c:109:#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
========== ETRAX_EXTERN_PB6CLK_ENABLED ==========
drivers/serial/crisv10.c:3445:#ifdef CONFIG_ETRAX_EXTERN_PB6CLK_ENABLED
========== ETRAX_RS485_LTC1387 ==========
drivers/serial/crisv10.c:1762:#if defined(CONFIG_ETRAX_RS485_LTC1387)
drivers/serial/crisv10.c:4397:#if defined(CONFIG_ETRAX_RS485_LTC1387)
========== ETRAX_RS485_ON_PORT_G ==========
drivers/serial/crisv10.c:471:#if defined(CONFIG_ETRAX_RS485_ON_PA) && defined(CONFIG_ETRAX_RS485_ON_PORT_G)
drivers/serial/crisv10.c:472:#error "Disable either CONFIG_ETRAX_RS485_ON_PA or CONFIG_ETRAX_RS485_ON_PORT_G"
drivers/serial/crisv10.c:845:#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
drivers/serial/crisv10.c:1758:#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
drivers/serial/crisv10.c:4393:#if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
========== ETRAX_SERIAL_PROC_ENTRY ==========
drivers/serial/crisv10.c:295: * CONFIG_ETRAX_SERIAL_PROC_ENTRY together.
drivers/serial/crisv10.c:299: * Added CONFIG_ETRAX_SERIAL_PROC_ENTRY for statistics and debug info.
drivers/serial/crisv10.c:813:#ifdef CONFIG_ETRAX_SERIAL_PROC_ENTRY
drivers/serial/crisv10.c:835:#endif /* CONFIG_ETRAX_SERIAL_PROC_ENTRY */
========== ETRAX_SERX_DTR_RI_DSR_CD_MIXED ==========
drivers/serial/crisv10.c:1097:#define CONFIG_ETRAX_SERX_DTR_RI_DSR_CD_MIXED
drivers/serial/crisv10.c:1100:#ifdef CONFIG_ETRAX_SERX_DTR_RI_DSR_CD_MIXED
drivers/serial/crisv10.c:1193:#else  /* CONFIG_ETRAX_SERX_DTR_RI_DSR_CD_MIXED */
drivers/serial/crisv10.c:1275:#endif /* !CONFIG_ETRAX_SERX_DTR_RI_DSR_CD_MIXED */
========== GILBARCO ==========
drivers/serial/mcfserial.c:64:      defined(CONFIG_M5329EVB) || defined(CONFIG_GILBARCO)
========== HARD_PPS ==========
drivers/serial/68360serial.c:559:#ifdef CONFIG_HARD_PPS
========== M68EZ328ADS ==========
drivers/serial/68328serial.c:109:#if defined(CONFIG_M68EZ328ADS) || defined(CONFIG_ALMA_ANS) || defined(CONFIG_DRAGONIXVZ)
arch/m68knommu/kernel/setup.c:199:      printk(KERN_INFO "M68EZ328ADS board support (C) 1999 Vladimir Gurevich <vgurevic@cisco.com>\n");
========== PP04 ==========
drivers/serial/68360serial.c:2522:#ifdef CONFIG_PP04
drivers/serial/68360serial.c:2523:      /* Frequentis PP04 forced to RS-232 until we know better.
========== SERIAL_CONSOLE_PORT ==========
drivers/serial/68360serial.c:57:#ifndef CONFIG_SERIAL_CONSOLE_PORT
drivers/serial/68360serial.c:58:#define CONFIG_SERIAL_CONSOLE_PORT      1 /* ie SMC2 - note USE_SMC2 must be defined */
drivers/serial/68360serial.c:65:#undef CONFIG_SERIAL_CONSOLE_PORT
drivers/serial/68360serial.c:66:#define CONFIG_SERIAL_CONSOLE_PORT      2
drivers/serial/68360serial.c:826:               if ((state - rs_table) != CONFIG_SERIAL_CONSOLE_PORT)
drivers/serial/68360serial.c:839:               if ((state - rs_table) != CONFIG_SERIAL_CONSOLE_PORT)
drivers/serial/68360serial.c:2405:      .index          = CONFIG_SERIAL_CONSOLE_PORT,
drivers/serial/68360serial.c:2558:              if (i == CONFIG_SERIAL_CONSOLE_PORT)
drivers/serial/68360serial.c:2714:                              if (i == CONFIG_SERIAL_CONSOLE_PORT)
drivers/serial/68360serial.c:2761:                              if (i == CONFIG_SERIAL_CONSOLE_PORT)
drivers/serial/68360serial.c:2781:                              if (i == CONFIG_SERIAL_CONSOLE_PORT)
drivers/serial/68360serial.c:2834:      ser = rs_table + CONFIG_SERIAL_CONSOLE_PORT;
========== SERIAL_CPM_ALT_SMC2 ==========
drivers/serial/cpm_uart/cpm_uart_core.c:959:#ifdef CONFIG_SERIAL_CPM_ALT_SMC2
========== SERIAL_SIO_SHARE_IRQ ==========
drivers/serial/m32r_sio.h:50:#ifdef CONFIG_SERIAL_SIO_SHARE_IRQ
========== SH_KGDB ==========
drivers/serial/sh-sci.c:81:#ifdef CONFIG_SH_KGDB
drivers/serial/sh-sci.c:98:    defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_SH_KGDB)
drivers/serial/sh-sci.c:126:#endif /* CONFIG_SH_STANDARD_BIOS || CONFIG_SH_KGDB */
drivers/serial/sh-sci.c:128:#if defined(CONFIG_SERIAL_SH_SCI_CONSOLE) || defined(CONFIG_SH_KGDB)
drivers/serial/sh-sci.c:155:#if defined(CONFIG_SH_STANDARD_BIOS) || defined(CONFIG_SH_KGDB)
drivers/serial/sh-sci.c:165:#ifdef CONFIG_SH_KGDBdrivers/serial/sh-sci.c:192:#endif /* CONFIG_SH_STANDARD_BIOS || CONFIG_SH_KGDB */
drivers/serial/sh-sci.c:201:#ifdef CONFIG_SH_KGDB
drivers/serial/sh-sci.c:217:#endif /* CONFIG_SH_KGDB */
drivers/serial/sh-sci.c:739:#ifdef CONFIG_SH_KGDB
drivers/serial/sh-sci.c:1264:#ifdef CONFIG_SH_KGDB
drivers/serial/sh-sci.c:1310:#endif /* CONFIG_SH_KGDB */

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
