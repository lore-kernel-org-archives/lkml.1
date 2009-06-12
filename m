Return-Path: <linux-kernel-owner+w=401wt.eu-S1765993AbZFLQ2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765993AbZFLQ2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764041AbZFLQZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39085 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764584AbZFLQZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:02 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 12/27] Blackfin: define SPI IRQ in board resources
Date: Fri, 12 Jun 2009 12:24:30 -0400
Message-Id: <1244823885-22410-13-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

The Blackfin SPI driver can be driven by an IRQ now, so declare it in
the board resources.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-bf518/boards/ezbrd.c      |   10 ++++++++++
 arch/blackfin/mach-bf527/boards/cm_bf527.c   |    5 +++++
 arch/blackfin/mach-bf527/boards/ezbrd.c      |    5 +++++
 arch/blackfin/mach-bf527/boards/ezkit.c      |    5 +++++
 arch/blackfin/mach-bf533/boards/H8606.c      |    5 +++++
 arch/blackfin/mach-bf533/boards/blackstamp.c |    5 +++++
 arch/blackfin/mach-bf533/boards/cm_bf533.c   |    5 +++++
 arch/blackfin/mach-bf533/boards/ezkit.c      |    5 +++++
 arch/blackfin/mach-bf533/boards/stamp.c      |    5 +++++
 arch/blackfin/mach-bf537/boards/cm_bf537.c   |    7 ++++++-
 arch/blackfin/mach-bf537/boards/minotaur.c   |    5 +++++
 arch/blackfin/mach-bf537/boards/pnav10.c     |    7 ++++++-
 arch/blackfin/mach-bf537/boards/tcm_bf537.c  |    5 +++++
 arch/blackfin/mach-bf538/boards/ezkit.c      |   10 ++++++++++
 arch/blackfin/mach-bf548/boards/cm_bf548.c   |   10 ++++++++++
 arch/blackfin/mach-bf548/boards/ezkit.c      |   10 ++++++++++
 arch/blackfin/mach-bf561/boards/cm_bf561.c   |    7 ++++++-
 arch/blackfin/mach-bf561/boards/ezkit.c      |    5 +++++
 18 files changed, 113 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/mach-bf518/boards/ezbrd.c b/arch/blackfin/mach-bf518/boards/ezbrd.c
index 62bba09..8969a24 100644
--- a/arch/blackfin/mach-bf518/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf518/boards/ezbrd.c
@@ -369,6 +369,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI0,
 		.end   = CH_SPI0,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI0,
+		.end   = IRQ_SPI0,
 		.flags = IORESOURCE_IRQ,
 	},
 };
@@ -399,6 +404,11 @@ static struct resource bfin_spi1_resource[] = {
 	[1] = {
 		.start = CH_SPI1,
 		.end   = CH_SPI1,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI1,
+		.end   = IRQ_SPI1,
 		.flags = IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/blackfin/mach-bf527/boards/cm_bf527.c b/arch/blackfin/mach-bf527/boards/cm_bf527.c
index 6d6f9ef..1eaf27f 100644
--- a/arch/blackfin/mach-bf527/boards/cm_bf527.c
+++ b/arch/blackfin/mach-bf527/boards/cm_bf527.c
@@ -664,6 +664,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/blackfin/mach-bf527/boards/ezbrd.c b/arch/blackfin/mach-bf527/boards/ezbrd.c
index 1435c5d..9f9c000 100644
--- a/arch/blackfin/mach-bf527/boards/ezbrd.c
+++ b/arch/blackfin/mach-bf527/boards/ezbrd.c
@@ -467,6 +467,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index 147edd1..3e5b7db 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -723,6 +723,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/blackfin/mach-bf533/boards/H8606.c b/arch/blackfin/mach-bf533/boards/H8606.c
index 895f213..38cf8ff 100644
--- a/arch/blackfin/mach-bf533/boards/H8606.c
+++ b/arch/blackfin/mach-bf533/boards/H8606.c
@@ -266,6 +266,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf533/boards/blackstamp.c b/arch/blackfin/mach-bf533/boards/blackstamp.c
index 0765872..9ecdc36 100644
--- a/arch/blackfin/mach-bf533/boards/blackstamp.c
+++ b/arch/blackfin/mach-bf533/boards/blackstamp.c
@@ -162,6 +162,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf533/boards/cm_bf533.c b/arch/blackfin/mach-bf533/boards/cm_bf533.c
index a727e53..1443e92 100644
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c
+++ b/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -160,6 +160,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf533/boards/ezkit.c b/arch/blackfin/mach-bf533/boards/ezkit.c
index 842f1c9..89a5ec4 100644
--- a/arch/blackfin/mach-bf533/boards/ezkit.c
+++ b/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -196,6 +196,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
index e19c565..a68ade8 100644
--- a/arch/blackfin/mach-bf533/boards/stamp.c
+++ b/arch/blackfin/mach-bf533/boards/stamp.c
@@ -299,6 +299,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf537/boards/cm_bf537.c b/arch/blackfin/mach-bf537/boards/cm_bf537.c
index 4fee196..2a87d1c 100644
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -182,8 +182,13 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
-	}
+	},
 };
 
 /* SPI controller data */
diff --git a/arch/blackfin/mach-bf537/boards/minotaur.c b/arch/blackfin/mach-bf537/boards/minotaur.c
index 3c15981..399f81d 100644
--- a/arch/blackfin/mach-bf537/boards/minotaur.c
+++ b/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -184,6 +184,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	},
 };
diff --git a/arch/blackfin/mach-bf537/boards/pnav10.c b/arch/blackfin/mach-bf537/boards/pnav10.c
index 26707ce..838240f 100644
--- a/arch/blackfin/mach-bf537/boards/pnav10.c
+++ b/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -398,8 +398,13 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
-	}
+	},
 };
 
 /* SPI controller data */
diff --git a/arch/blackfin/mach-bf537/boards/tcm_bf537.c b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
index 2805745..e523e6e 100644
--- a/arch/blackfin/mach-bf537/boards/tcm_bf537.c
+++ b/arch/blackfin/mach-bf537/boards/tcm_bf537.c
@@ -182,6 +182,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf538/boards/ezkit.c b/arch/blackfin/mach-bf538/boards/ezkit.c
index e37cb93..57695b4 100644
--- a/arch/blackfin/mach-bf538/boards/ezkit.c
+++ b/arch/blackfin/mach-bf538/boards/ezkit.c
@@ -352,6 +352,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI0,
 		.end   = CH_SPI0,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI0,
+		.end   = IRQ_SPI0,
 		.flags = IORESOURCE_IRQ,
 	}
 };
@@ -366,6 +371,11 @@ static struct resource bfin_spi1_resource[] = {
 	[1] = {
 		.start = CH_SPI1,
 		.end   = CH_SPI1,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI1,
+		.end   = IRQ_SPI1,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf548/boards/cm_bf548.c b/arch/blackfin/mach-bf548/boards/cm_bf548.c
index f53ad68..f5a3c30 100644
--- a/arch/blackfin/mach-bf548/boards/cm_bf548.c
+++ b/arch/blackfin/mach-bf548/boards/cm_bf548.c
@@ -612,6 +612,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI0,
 		.end   = CH_SPI0,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI0,
+		.end   = IRQ_SPI0,
 		.flags = IORESOURCE_IRQ,
 	}
 };
@@ -626,6 +631,11 @@ static struct resource bfin_spi1_resource[] = {
 	[1] = {
 		.start = CH_SPI1,
 		.end   = CH_SPI1,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI1,
+		.end   = IRQ_SPI1,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf548/boards/ezkit.c b/arch/blackfin/mach-bf548/boards/ezkit.c
index add5a17..a4b1ee8 100644
--- a/arch/blackfin/mach-bf548/boards/ezkit.c
+++ b/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -741,6 +741,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI0,
 		.end   = CH_SPI0,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI0,
+		.end   = IRQ_SPI0,
 		.flags = IORESOURCE_IRQ,
 	}
 };
@@ -755,6 +760,11 @@ static struct resource bfin_spi1_resource[] = {
 	[1] = {
 		.start = CH_SPI1,
 		.end   = CH_SPI1,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI1,
+		.end   = IRQ_SPI1,
 		.flags = IORESOURCE_IRQ,
 	}
 };
diff --git a/arch/blackfin/mach-bf561/boards/cm_bf561.c b/arch/blackfin/mach-bf561/boards/cm_bf561.c
index 0dd9685..0c9d72c 100644
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c
+++ b/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -177,8 +177,13 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
-	}
+	},
 };
 
 /* SPI controller data */
diff --git a/arch/blackfin/mach-bf561/boards/ezkit.c b/arch/blackfin/mach-bf561/boards/ezkit.c
index 0e2178a..b5ef7ff 100644
--- a/arch/blackfin/mach-bf561/boards/ezkit.c
+++ b/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -304,6 +304,11 @@ static struct resource bfin_spi0_resource[] = {
 	[1] = {
 		.start = CH_SPI,
 		.end   = CH_SPI,
+		.flags = IORESOURCE_DMA,
+	},
+	[2] = {
+		.start = IRQ_SPI,
+		.end   = IRQ_SPI,
 		.flags = IORESOURCE_IRQ,
 	}
 };
-- 
1.6.3.1

