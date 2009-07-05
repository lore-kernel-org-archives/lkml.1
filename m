Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbZGEWcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbZGEWcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 18:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZGEWcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 18:32:01 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:38456 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbZGEWcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 18:32:00 -0400
Date: Sun, 5 Jul 2009 23:30:51 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: skuribay@ruby.dti.ne.jp, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Trivial: Fix filenames in their headers for the
	EMMA Mark-eins.
Message-ID: <20090705223051.GA18858@linux-mips.org>
References: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different suggestion - let's remove these comment lines entirely.  I just
don't see any use for them.  So this patch removes them along with a few
very obvious comments.

  Ralf

 arch/mips/dec/ecc-berr.c                          |    2 --
 arch/mips/dec/int-handler.S                       |    2 --
 arch/mips/dec/ioasic-irq.c                        |    2 --
 arch/mips/dec/kn01-berr.c                         |    2 --
 arch/mips/dec/kn02-irq.c                          |    2 --
 arch/mips/dec/kn02xa-berr.c                       |    2 --
 arch/mips/dec/prom/call_o32.S                     |    2 --
 arch/mips/dec/prom/console.c                      |    2 --
 arch/mips/dec/time.c                              |    2 --
 arch/mips/emma/common/Makefile                    |    3 ---
 arch/mips/emma/common/prom.c                      |    3 ---
 arch/mips/emma/markeins/Makefile                  |    3 ---
 arch/mips/emma/markeins/irq.c                     |    3 ---
 arch/mips/emma/markeins/led.c                     |    3 ---
 arch/mips/emma/markeins/platform.c                |    3 ---
 arch/mips/emma/markeins/setup.c                   |    3 ---
 arch/mips/include/asm/emma/emma2rh.h              |    3 ---
 arch/mips/include/asm/emma/markeins.h             |    3 ---
 arch/mips/kernel/irq_txx9.c                       |    2 --
 arch/mips/kernel/proc.c                           |    2 --
 arch/mips/kernel/stacktrace.c                     |    2 --
 arch/mips/mm/extable.c                            |    3 ---
 arch/mips/pci/fixup-emma2rh.c                     |    3 ---
 arch/mips/pci/fixup-sb1250.c                      |    2 --
 arch/mips/pci/ops-emma2rh.c                       |    3 ---
 arch/mips/pci/pci-emma2rh.c                       |    3 ---
 arch/mips/pci/pci-tx4927.c                        |    2 --
 arch/mips/pci/pci-tx4938.c                        |    2 --
 arch/mips/pci/pci-tx4939.c                        |    2 --
 arch/mips/pmc-sierra/msp71xx/gpio.c               |    2 --
 arch/mips/pmc-sierra/msp71xx/gpio_extended.c      |    2 --
 arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c |    2 --
 arch/mips/sibyte/swarm/swarm-i2c.c                |    2 --
 arch/mips/txx9/generic/mem_tx4927.c               |    2 --
 arch/mips/txx9/generic/setup.c                    |    2 --
 35 files changed, 0 insertions(+), 83 deletions(-)

diff --git a/arch/mips/dec/ecc-berr.c b/arch/mips/dec/ecc-berr.c
index 6a17c9b..7abce66 100644
--- a/arch/mips/dec/ecc-berr.c
+++ b/arch/mips/dec/ecc-berr.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/mips/dec/ecc-berr.c
- *
  *	Bus error event handling code for systems equipped with ECC
  *	handling logic, i.e. DECstation/DECsystem 5000/200 (KN02),
  *	5000/240 (KN03), 5000/260 (KN05) and DECsystem 5900 (KN03),
diff --git a/arch/mips/dec/int-handler.S b/arch/mips/dec/int-handler.S
index 00cecdc..82c8528 100644
--- a/arch/mips/dec/int-handler.S
+++ b/arch/mips/dec/int-handler.S
@@ -1,6 +1,4 @@
 /*
- * arch/mips/dec/int-handler.S
- *
  * Copyright (C) 1995, 1996, 1997 Paul M. Antoine and Harald Koerfgen
  * Copyright (C) 2000, 2001, 2002, 2003, 2005  Maciej W. Rozycki
  *
diff --git a/arch/mips/dec/ioasic-irq.c b/arch/mips/dec/ioasic-irq.c
index 3acb133..cb41954 100644
--- a/arch/mips/dec/ioasic-irq.c
+++ b/arch/mips/dec/ioasic-irq.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/mips/dec/ioasic-irq.c
- *
  *	DEC I/O ASIC interrupts.
  *
  *	Copyright (c) 2002, 2003  Maciej W. Rozycki
diff --git a/arch/mips/dec/kn01-berr.c b/arch/mips/dec/kn01-berr.c
index d3b8002..b0dc6d5 100644
--- a/arch/mips/dec/kn01-berr.c
+++ b/arch/mips/dec/kn01-berr.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/mips/dec/kn01-berr.c
- *
  *	Bus error event handling code for DECstation/DECsystem 3100
  *	and 2100 (KN01) systems equipped with parity error detection
  *	logic.
diff --git a/arch/mips/dec/kn02-irq.c b/arch/mips/dec/kn02-irq.c
index 02439dc..ed90a8d 100644
--- a/arch/mips/dec/kn02-irq.c
+++ b/arch/mips/dec/kn02-irq.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/mips/dec/kn02-irq.c
- *
  *	DECstation 5000/200 (KN02) Control and Status Register
  *	interrupts.
  *
diff --git a/arch/mips/dec/kn02xa-berr.c b/arch/mips/dec/kn02xa-berr.c
index 5f04545..07ca540 100644
--- a/arch/mips/dec/kn02xa-berr.c
+++ b/arch/mips/dec/kn02xa-berr.c
@@ -1,6 +1,4 @@
 /*
- *	linux/arch/mips/dec/kn02xa-berr.c
- *
  *	Bus error event handling code for 5000-series systems equipped
  *	with parity error detection logic, i.e. DECstation/DECsystem
  *	5000/120, /125, /133 (KN02-BA), 5000/150 (KN04-BA) and Personal
diff --git a/arch/mips/dec/prom/call_o32.S b/arch/mips/dec/prom/call_o32.S
index e523454..8c84981 100644
--- a/arch/mips/dec/prom/call_o32.S
+++ b/arch/mips/dec/prom/call_o32.S
@@ -1,6 +1,4 @@
 /*
- *	arch/mips/dec/prom/call_o32.S
- *
  *	O32 interface for the 64 (or N32) ABI.
  *
  *	Copyright (C) 2002  Maciej W. Rozycki
diff --git a/arch/mips/dec/prom/console.c b/arch/mips/dec/prom/console.c
index 078e1a1..caa6e04 100644
--- a/arch/mips/dec/prom/console.c
+++ b/arch/mips/dec/prom/console.c
@@ -1,6 +1,4 @@
 /*
- *	arch/mips/dec/prom/console.c
- *
  *	DECstation PROM-based early console support.
  *
  *	Copyright (C) 2004, 2007  Maciej W. Rozycki
diff --git a/arch/mips/dec/time.c b/arch/mips/dec/time.c
index 1359c03..463136e 100644
--- a/arch/mips/dec/time.c
+++ b/arch/mips/dec/time.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/mips/dec/time.c
- *
  *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
  *  Copyright (C) 2000, 2003  Maciej W. Rozycki
  *
diff --git a/arch/mips/emma/common/Makefile b/arch/mips/emma/common/Makefile
index c392d28..f27d84d 100644
--- a/arch/mips/emma/common/Makefile
+++ b/arch/mips/emma/common/Makefile
@@ -1,7 +1,4 @@
 #
-#  arch/mips/emma2rh/common/Makefile
-#       Makefile for the common code of NEC EMMA2RH based board.
-#
 #  Copyright (C) NEC Electronics Corporation 2005-2006
 #
 #  This program is free software; you can redistribute it and/or modify
diff --git a/arch/mips/emma/common/prom.c b/arch/mips/emma/common/prom.c
index 120f53f..708f087 100644
--- a/arch/mips/emma/common/prom.c
+++ b/arch/mips/emma/common/prom.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/emma2rh/common/prom.c
- *      This file is prom file.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This file is based on the arch/mips/ddb5xxx/common/prom.c
diff --git a/arch/mips/emma/markeins/Makefile b/arch/mips/emma/markeins/Makefile
index 16e0017..f8ba250 100644
--- a/arch/mips/emma/markeins/Makefile
+++ b/arch/mips/emma/markeins/Makefile
@@ -1,7 +1,4 @@
 #
-#  arch/mips/emma2rh/markeins/Makefile
-#       Makefile for the common code of NEC EMMA2RH based board.
-#
 #  Copyright (C) NEC Electronics Corporation 2005-2006
 #
 #  This program is free software; you can redistribute it and/or modify
diff --git a/arch/mips/emma/markeins/irq.c b/arch/mips/emma/markeins/irq.c
index 43828ae..9504b7e 100644
--- a/arch/mips/emma/markeins/irq.c
+++ b/arch/mips/emma/markeins/irq.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/emma2rh/markeins/irq.c
- *      This file defines the irq handler for EMMA2RH.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This file is based on the arch/mips/ddb5xxx/ddb5477/irq.c
diff --git a/arch/mips/emma/markeins/led.c b/arch/mips/emma/markeins/led.c
index 377a181..4975589 100644
--- a/arch/mips/emma/markeins/led.c
+++ b/arch/mips/emma/markeins/led.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/emma2rh/markeins/led.c
- *      This file defines the led display for Mark-eins.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This program is free software; you can redistribute it and/or modify
diff --git a/arch/mips/emma/markeins/platform.c b/arch/mips/emma/markeins/platform.c
index 80ae12e..b05b08b 100644
--- a/arch/mips/emma/markeins/platform.c
+++ b/arch/mips/emma/markeins/platform.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/emma2rh/markeins/platofrm.c
- *      This file sets up platform devices for EMMA2RH Mark-eins.
- *
  *  Copyright(C) MontaVista Software Inc, 2006
  *
  *  Author: dmitry pervushin <dpervushin@ru.mvista.com>
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index 67f4565..335dc8c 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/emma2rh/markeins/setup.c
- *      This file is setup for EMMA2RH Mark-eins.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This file is based on the arch/mips/ddb5xxx/ddb5477/setup.c.
diff --git a/arch/mips/include/asm/emma/emma2rh.h b/arch/mips/include/asm/emma/emma2rh.h
index 30aea91..2afb2fe 100644
--- a/arch/mips/include/asm/emma/emma2rh.h
+++ b/arch/mips/include/asm/emma/emma2rh.h
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/include/asm/emma/emma2rh.h
- *      This file is EMMA2RH common header.
- *
  *  Copyright (C) NEC Electronics Corporation 2005-2006
  *
  *  This file based on include/asm-mips/ddb5xxx/ddb5xxx.h
diff --git a/arch/mips/include/asm/emma/markeins.h b/arch/mips/include/asm/emma/markeins.h
index 973b062..2618bf2 100644
--- a/arch/mips/include/asm/emma/markeins.h
+++ b/arch/mips/include/asm/emma/markeins.h
@@ -1,7 +1,4 @@
 /*
- *  include/asm-mips/emma2rh/markeins.h
- *      This file is EMMA2RH board depended header.
- *
  *  Copyright (C) NEC Electronics Corporation 2005-2006
  *
  *  This file based on include/asm-mips/ddb5xxx/ddb5xxx.h
diff --git a/arch/mips/kernel/irq_txx9.c b/arch/mips/kernel/irq_txx9.c
index a4d1462..9b78029 100644
--- a/arch/mips/kernel/irq_txx9.c
+++ b/arch/mips/kernel/irq_txx9.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/mips/kernel/irq_txx9.c
- *
  * Based on linux/arch/mips/jmr3927/rbhma3100/irq.c,
  *          linux/arch/mips/tx4927/common/tx4927_irq.c,
  *          linux/arch/mips/tx4938/common/irq.c
diff --git a/arch/mips/kernel/proc.c b/arch/mips/kernel/proc.c
index e0a4ac1..26109c4 100644
--- a/arch/mips/kernel/proc.c
+++ b/arch/mips/kernel/proc.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/mips/kernel/proc.c
- *
  *  Copyright (C) 1995, 1996, 2001  Ralf Baechle
  *  Copyright (C) 2001, 2004  MIPS Technologies, Inc.
  *  Copyright (C) 2004  Maciej W. Rozycki
diff --git a/arch/mips/kernel/stacktrace.c b/arch/mips/kernel/stacktrace.c
index 58f5cd7..d52ff77 100644
--- a/arch/mips/kernel/stacktrace.c
+++ b/arch/mips/kernel/stacktrace.c
@@ -1,6 +1,4 @@
 /*
- * arch/mips/kernel/stacktrace.c
- *
  * Stack trace management functions
  *
  *  Copyright (C) 2006 Atsushi Nemoto <anemo@mba.ocn.ne.jp>
diff --git a/arch/mips/mm/extable.c b/arch/mips/mm/extable.c
index 297fb9f..e94ea59 100644
--- a/arch/mips/mm/extable.c
+++ b/arch/mips/mm/extable.c
@@ -1,6 +1,3 @@
-/*
- * linux/arch/mips/mm/extable.c
- */
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <asm/branch.h>
diff --git a/arch/mips/pci/fixup-emma2rh.c b/arch/mips/pci/fixup-emma2rh.c
index fba5aad..0d9ccf4 100644
--- a/arch/mips/pci/fixup-emma2rh.c
+++ b/arch/mips/pci/fixup-emma2rh.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/pci/fixup-emma2rh.c
- *      This file defines the PCI configration.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This file is based on the arch/mips/ddb5xxx/ddb5477/pci.c
diff --git a/arch/mips/pci/fixup-sb1250.c b/arch/mips/pci/fixup-sb1250.c
index 0ad39e5..f0bb914 100644
--- a/arch/mips/pci/fixup-sb1250.c
+++ b/arch/mips/pci/fixup-sb1250.c
@@ -1,6 +1,4 @@
 /*
- *	arch/mips/pci/fixup-sb1250.c
- *
  *	Copyright (C) 2004, 2006  MIPS Technologies, Inc.  All rights reserved.
  *	    Author:	Maciej W. Rozycki <macro@mips.com>
  *
diff --git a/arch/mips/pci/ops-emma2rh.c b/arch/mips/pci/ops-emma2rh.c
index 5947a70..710aef5 100644
--- a/arch/mips/pci/ops-emma2rh.c
+++ b/arch/mips/pci/ops-emma2rh.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/pci/ops-emma2rh.c
- *      This file defines the PCI operation for EMMA2RH.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This file is based on the arch/mips/pci/ops-vr41xx.c
diff --git a/arch/mips/pci/pci-emma2rh.c b/arch/mips/pci/pci-emma2rh.c
index 2df4190..773e34f 100644
--- a/arch/mips/pci/pci-emma2rh.c
+++ b/arch/mips/pci/pci-emma2rh.c
@@ -1,7 +1,4 @@
 /*
- *  arch/mips/pci/pci-emma2rh.c
- *      This file defines the PCI configration.
- *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
  *
  *  This file is based on the arch/mips/ddb5xxx/ddb5477/pci.c
diff --git a/arch/mips/pci/pci-tx4927.c b/arch/mips/pci/pci-tx4927.c
index aaa9005..a580740 100644
--- a/arch/mips/pci/pci-tx4927.c
+++ b/arch/mips/pci/pci-tx4927.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/mips/pci/pci-tx4927.c
- *
  * Based on linux/arch/mips/txx9/rbtx4938/setup.c,
  *	    and RBTX49xx patch from CELF patch archive.
  *
diff --git a/arch/mips/pci/pci-tx4938.c b/arch/mips/pci/pci-tx4938.c
index 1ea257b..20e45f3 100644
--- a/arch/mips/pci/pci-tx4938.c
+++ b/arch/mips/pci/pci-tx4938.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/mips/pci/pci-tx4938.c
- *
  * Based on linux/arch/mips/txx9/rbtx4938/setup.c,
  *	    and RBTX49xx patch from CELF patch archive.
  *
diff --git a/arch/mips/pci/pci-tx4939.c b/arch/mips/pci/pci-tx4939.c
index 5fecf1c..9ef8406 100644
--- a/arch/mips/pci/pci-tx4939.c
+++ b/arch/mips/pci/pci-tx4939.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/mips/pci/pci-tx4939.c
- *
  * Based on linux/arch/mips/txx9/rbtx4939/setup.c,
  *	    and RBTX49xx patch from CELF patch archive.
  *
diff --git a/arch/mips/pmc-sierra/msp71xx/gpio.c b/arch/mips/pmc-sierra/msp71xx/gpio.c
index 69848c5..aaccbe5 100644
--- a/arch/mips/pmc-sierra/msp71xx/gpio.c
+++ b/arch/mips/pmc-sierra/msp71xx/gpio.c
@@ -1,6 +1,4 @@
 /*
- * @file /arch/mips/pmc-sierra/msp71xx/gpio.c
- *
  * Generic PMC MSP71xx GPIO handling. These base gpio are controlled by two
  * types of registers. The data register sets the output level when in output
  * mode and when in input mode will contain the value at the input. The config
diff --git a/arch/mips/pmc-sierra/msp71xx/gpio_extended.c b/arch/mips/pmc-sierra/msp71xx/gpio_extended.c
index fc6dbc6..2a99f36 100644
--- a/arch/mips/pmc-sierra/msp71xx/gpio_extended.c
+++ b/arch/mips/pmc-sierra/msp71xx/gpio_extended.c
@@ -1,6 +1,4 @@
 /*
- * @file /arch/mips/pmc-sierra/msp71xx/gpio_extended.c
- *
  * Generic PMC MSP71xx EXTENDED (EXD) GPIO handling. The extended gpio is
  * a set of hardware registers that have no need for explicit locking as
  * it is handled by unique method of writing individual set/clr bits.
diff --git a/arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c b/arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c
index caf5e9a..fc990cb 100644
--- a/arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c
+++ b/arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c
@@ -1,6 +1,4 @@
 /*
- *  arch/mips/pmc-sierra/yosemite/atmel_read_eeprom.c
- *
  *  Copyright (C) 2003 PMC-Sierra Inc.
  *  Author: Manish Lachwani (lachwani@pmc-sierra.com)
  *
diff --git a/arch/mips/sibyte/swarm/swarm-i2c.c b/arch/mips/sibyte/swarm/swarm-i2c.c
index 4282ac9..0625050 100644
--- a/arch/mips/sibyte/swarm/swarm-i2c.c
+++ b/arch/mips/sibyte/swarm/swarm-i2c.c
@@ -1,6 +1,4 @@
 /*
- *	arch/mips/sibyte/swarm/swarm-i2c.c
- *
  *	Broadcom BCM91250A (SWARM), etc. I2C platform setup.
  *
  *	Copyright (c) 2008  Maciej W. Rozycki
diff --git a/arch/mips/txx9/generic/mem_tx4927.c b/arch/mips/txx9/generic/mem_tx4927.c
index ef6ea6e..70f9626 100644
--- a/arch/mips/txx9/generic/mem_tx4927.c
+++ b/arch/mips/txx9/generic/mem_tx4927.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/mips/txx9/generic/mem_tx4927.c
- *
  * common tx4927 memory interface
  *
  * Author: MontaVista Software, Inc.
diff --git a/arch/mips/txx9/generic/setup.c b/arch/mips/txx9/generic/setup.c
index 3b7d77d..a205e2b 100644
--- a/arch/mips/txx9/generic/setup.c
+++ b/arch/mips/txx9/generic/setup.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/mips/txx9/generic/setup.c
- *
  * Based on linux/arch/mips/txx9/rbtx4938/setup.c,
  *	    and RBTX49xx patch from CELF patch archive.
  *
