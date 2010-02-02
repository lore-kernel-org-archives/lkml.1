Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab0BBHWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1766 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755575Ab0BBHWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:25 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 08/10] drivers/staging: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:14 -0800
Message-Id: <c46c977d3a3f5d10f0850e89b364affd65234865.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/rtl8192su/r8192S_phy.c |   16 ++++++++--------
 drivers/staging/sep/sep_driver.c       |    5 +++--
 drivers/staging/slicoss/slicoss.c      |    6 ++----
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192S_phy.c b/drivers/staging/rtl8192su/r8192S_phy.c
index 77ab026..63d4e5f 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -2407,8 +2407,8 @@ void PHY_SetBWModeCallback8192S(struct net_device *dev)
 			break;
 
 		default:
-			RT_TRACE(COMP_DBG, "SetBWModeCallback8190Pci():\
-						unknown Bandwidth: %#X\n",priv->CurrentChannelBW);
+			RT_TRACE(COMP_DBG, "SetBWModeCallback8190Pci(): unknown Bandwidth: %#X\n",
+				 priv->CurrentChannelBW);
 			break;
 	}
 
@@ -3398,8 +3398,8 @@ void SwChnlCallback8192SUsb(struct net_device *dev)
 	u32			delay;
 //	bool			ret;
 
-	RT_TRACE(COMP_SCAN, "==>SwChnlCallback8190Pci(), switch to channel\
-				%d\n", priv->chan);
+	RT_TRACE(COMP_SCAN, "==>SwChnlCallback8190Pci(), switch to channel %d\n",
+		 priv->chan);
 
 
 	if(!priv->up)
@@ -3525,8 +3525,8 @@ void SetBWModeCallback8192SUsb(struct net_device *dev)
 			break;
 
 		default:
-			RT_TRACE(COMP_DBG, "SetChannelBandwidth8190Pci():\
-						unknown Bandwidth: %#X\n",priv->CurrentChannelBW);
+			RT_TRACE(COMP_DBG, "SetChannelBandwidth8190Pci(): unknown Bandwidth: %#X\n",
+				 priv->CurrentChannelBW);
 			break;
 	}
 
@@ -3660,8 +3660,8 @@ void SetBWModeCallback8192SUsbWorkItem(struct net_device *dev)
 			break;
 
 		default:
-			RT_TRACE(COMP_DBG, "SetBWModeCallback8192SUsbWorkItem():\
-						unknown Bandwidth: %#X\n",priv->CurrentChannelBW);
+			RT_TRACE(COMP_DBG, "SetBWModeCallback8192SUsbWorkItem(): unknown Bandwidth: %#X\n",
+				 priv->CurrentChannelBW);
 			break;
 	}
 
diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 8793878..54234f1 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -940,8 +940,9 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			dbg("data_size is %lu\n", data_size);
 			while (1);
 		}
-		edbg("lli_array[%lu].physical_address is %08lx, \
-		lli_array[%lu].block_size is %lu\n", count, lli_array[count].physical_address, count, lli_array[count].block_size);
+		edbg("lli_array[%lu].physical_address is %08lx, lli_array[%lu].block_size is %lu\n",
+		     count, lli_array[count].physical_address,
+		     count, lli_array[count].block_size);
 	}
 
 	/* set output params */
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 5b191af..4e5158a 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -649,8 +649,7 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 
 			if (copy_from_user(data, rq->ifr_data, 28)) {
 				PRINT_ERROR
-				    ("slic: copy_from_user FAILED getting \
-				     initial simba param\n");
+				    ("slic: copy_from_user FAILED getting initial simba param\n");
 				return -EFAULT;
 			}
 
@@ -665,8 +664,7 @@ static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 				   (tracemon_request ==
 				    SLIC_DUMP_IN_PROGRESS)) {
 				PRINT_ERROR
-				    ("ATK Diagnostic Trace Dump Requested but \
-				     already in progress... ignore\n");
+				    ("ATK Diagnostic Trace Dump Requested but already in progress... ignore\n");
 			} else {
 				PRINT_ERROR
 				    ("ATK Diagnostic Trace Dump Requested\n");
-- 
1.6.6.rc0.57.gad7a

