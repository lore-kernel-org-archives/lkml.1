Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZJHGHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZJHGHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZJHGHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:07:05 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34522 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001AbZJHGFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Barry Song <barry.song@analog.com>
Subject: [PATCH 03/13] Blackfin: BF51x: add PTP MMR defines
Date: Thu,  8 Oct 2009 02:04:19 -0400
Message-Id: <1254981869-21586-4-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Barry Song <barry.song@analog.com>

---
 arch/blackfin/mach-bf518/include/mach/cdefBF518.h |   41 +++++++++++++++++++++
 arch/blackfin/mach-bf518/include/mach/defBF518.h  |   28 ++++++++++++++
 2 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-bf518/include/mach/cdefBF518.h b/arch/blackfin/mach-bf518/include/mach/cdefBF518.h
index fd92f6e..929b906 100644
--- a/arch/blackfin/mach-bf518/include/mach/cdefBF518.h
+++ b/arch/blackfin/mach-bf518/include/mach/cdefBF518.h
@@ -186,6 +186,47 @@
 #define bfin_read_EMAC_TXC_ABORT()		bfin_read32(EMAC_TXC_ABORT)
 #define bfin_write_EMAC_TXC_ABORT(val)		bfin_write32(EMAC_TXC_ABORT, val)
 
+#define bfin_read_EMAC_PTP_CTL()                bfin_read16(EMAC_PTP_CTL)
+#define bfin_write_EMAC_PTP_CTL(val)            bfin_write16(EMAC_PTP_CTL, val)
+#define bfin_read_EMAC_PTP_IE()                 bfin_read16(EMAC_PTP_IE)
+#define bfin_write_EMAC_PTP_IE(val)             bfin_write16(EMAC_PTP_IE, val)
+#define bfin_read_EMAC_PTP_ISTAT()              bfin_read16(EMAC_PTP_ISTAT)
+#define bfin_write_EMAC_PTP_ISTAT(val)          bfin_write16(EMAC_PTP_ISTAT, val)
+#define bfin_read_EMAC_PTP_FOFF()               bfin_read32(EMAC_PTP_FOFF)
+#define bfin_write_EMAC_PTP_FOFF(val)           bfin_write32(EMAC_PTP_FOFF, val)
+#define bfin_read_EMAC_PTP_FV1()                bfin_read32(EMAC_PTP_FV1)
+#define bfin_write_EMAC_PTP_FV1(val)            bfin_write32(EMAC_PTP_FV1, val)
+#define bfin_read_EMAC_PTP_FV2()                bfin_read32(EMAC_PTP_FV2)
+#define bfin_write_EMAC_PTP_FV2(val)            bfin_write32(EMAC_PTP_FV2, val)
+#define bfin_read_EMAC_PTP_FV3()                bfin_read32(EMAC_PTP_FV3)
+#define bfin_write_EMAC_PTP_FV3(val)            bfin_write32(EMAC_PTP_FV3, val)
+#define bfin_read_EMAC_PTP_ADDEND()             bfin_read32(EMAC_PTP_ADDEND)
+#define bfin_write_EMAC_PTP_ADDEND(val)         bfin_write32(EMAC_PTP_ADDEND, val)
+#define bfin_read_EMAC_PTP_ACCR()               bfin_read32(EMAC_PTP_ACCR)
+#define bfin_write_EMAC_PTP_ACCR(val)           bfin_write32(EMAC_PTP_ACCR, val)
+#define bfin_read_EMAC_PTP_OFFSET()             bfin_read32(EMAC_PTP_OFFSET)
+#define bfin_write_EMAC_PTP_OFFSET(val)         bfin_write32(EMAC_PTP_OFFSET, val)
+#define bfin_read_EMAC_PTP_TIMELO()             bfin_read32(EMAC_PTP_TIMELO)
+#define bfin_write_EMAC_PTP_TIMELO(val)         bfin_write32(EMAC_PTP_TIMELO, val)
+#define bfin_read_EMAC_PTP_TIMEHI()             bfin_read32(EMAC_PTP_TIMEHI)
+#define bfin_write_EMAC_PTP_TIMEHI(val)         bfin_write32(EMAC_PTP_TIMEHI, val)
+#define bfin_read_EMAC_PTP_RXSNAPLO()           bfin_read32(EMAC_PTP_RXSNAPLO)
+#define bfin_read_EMAC_PTP_RXSNAPHI()           bfin_read32(EMAC_PTP_RXSNAPHI)
+#define bfin_read_EMAC_PTP_TXSNAPLO()           bfin_read32(EMAC_PTP_TXSNAPLO)
+#define bfin_read_EMAC_PTP_TXSNAPHI()           bfin_read32(EMAC_PTP_TXSNAPHI)
+#define bfin_read_EMAC_PTP_ALARMLO()            bfin_read32(EMAC_PTP_ALARMLO)
+#define bfin_write_EMAC_PTP_ALARMLO(val)        bfin_write32(EMAC_PTP_ALARMLO, val)
+#define bfin_read_EMAC_PTP_ALARMHI()            bfin_read32(EMAC_PTP_ALARMHI)
+#define bfin_write_EMAC_PTP_ALARMHI(val)        bfin_write32(EMAC_PTP_ALARMHI, val)
+#define bfin_read_EMAC_PTP_ID_OFF()             bfin_read16(EMAC_PTP_ID_OFF)
+#define bfin_write_EMAC_PTP_ID_OFF(val)         bfin_write16(EMAC_PTP_ID_OFF, val)
+#define bfin_read_EMAC_PTP_ID_SNAP()            bfin_read32(EMAC_PTP_ID_SNAP)
+#define bfin_write_EMAC_PTP_ID_SNAP(val)        bfin_write32(EMAC_PTP_ID_SNAP, val)
+#define bfin_read_EMAC_PTP_PPS_STARTHI()        bfin_read32(EMAC_PTP_PPS_STARTHI)
+#define bfin_write_EMAC_PTP_PPS_STARTHI(val)    bfin_write32(EMAC_PTP_PPS_STARTHI, val)
+#define bfin_read_EMAC_PTP_PPS_PERIOD()         bfin_read32(EMAC_PTP_PPS_PERIOD)
+#define bfin_write_EMAC_PTP_PPS_PERIOD(val)     bfin_write32(EMAC_PTP_PPS_PERIOD, val)
+
 /* Removable Storage Interface Registers */
 
 #define bfin_read_RSI_PWR_CTL()        bfin_read16(RSI_PWR_CONTROL)
diff --git a/arch/blackfin/mach-bf518/include/mach/defBF518.h b/arch/blackfin/mach-bf518/include/mach/defBF518.h
index 16b7eef..794cf06 100644
--- a/arch/blackfin/mach-bf518/include/mach/defBF518.h
+++ b/arch/blackfin/mach-bf518/include/mach/defBF518.h
@@ -624,4 +624,32 @@
 
 #define                       RWR  0x1        /* Read Wait Request */
 
+/* Bit masks for EMAC_PTP_CTL */
+
+#define                    PTP_EN  0x1        /* Enable the PTP_TSYNC module */
+#define                        TL  0x2        /* Timestamp lock control */
+#define                      ASEN  0x10       /* Auxiliary snapshot control */
+#define                     PPSEN  0x80       /* Pulse-per-second (PPS) control */
+#define                     CKOEN  0x2000     /* Clock output control */
+
+/* Bit masks for EMAC_PTP_IE */
+
+#define                      ALIE  0x1        /* Alarm interrupt enable */
+#define                     RXEIE  0x2        /* Receive event interrupt enable */
+#define                     RXGIE  0x4        /* Receive general interrupt enable */
+#define                      TXIE  0x8        /* Transmit interrupt enable */
+#define                     RXOVE  0x10       /* Receive overrun error interrupt enable */
+#define                     TXOVE  0x20       /* Transmit overrun error interrupt enable */
+#define                      ASIE  0x40       /* Auxiliary snapshot interrupt enable */
+
+/* Bit masks for EMAC_PTP_ISTAT */
+
+#define                       ALS  0x1        /* Alarm status */
+#define                      RXEL  0x2        /* Receive event interrupt status */
+#define                      RXGL  0x4        /* Receive general interrupt status */
+#define                      TXTL  0x8        /* Transmit snapshot status */
+#define                      RXOV  0x10       /* Receive snapshot overrun status */
+#define                      TXOV  0x20       /* Transmit snapshot overrun status */
+#define                       ASL  0x40       /* Auxiliary snapshot interrupt status */
+
 #endif /* _DEF_BF518_H */
-- 
1.6.5.rc2

