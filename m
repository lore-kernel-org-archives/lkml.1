Return-Path: <linux-kernel-owner+w=401wt.eu-S1758293AbZGGOec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293AbZGGOec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbZGGOeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:34:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:42673 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758249AbZGGOeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:34:03 -0400
Subject: [PATCH 6/22] trivial: fix typo "bit bit" in multiple files
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: trivial <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 19:41:24 +0530
Message-Id: <1246975884.3613.19.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Replaced "bit bit" with "bit" in multiple files

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 drivers/staging/rtl8192su/r8192S_phy.c |    2 +-
 drivers/staging/rtl8192su/r819xU_phy.c |    2 +-
 sound/isa/cs423x/cs4236_lib.c          |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8192su/r8192S_phy.c b/drivers/staging/rtl8192su/r8192S_phy.c
index 99a4051..b5f6aa5 100644
--- a/drivers/staging/rtl8192su/r8192S_phy.c
+++ b/drivers/staging/rtl8192su/r8192S_phy.c
@@ -1301,7 +1301,7 @@ phy_RFSerialWrite(struct net_device* dev,RF90_RADIO_PATH_E eRFPath,u32 Offset,u3
 *			u32		BitMask,
 *
 * Output:	none
-* Return:		u32		Return the shift bit bit position of the mask
+* Return:		u32		Return the shift bit position of the mask
 */
 //use in phy only
 static u32 phy_CalculateBitShift(u32 BitMask)
diff --git a/drivers/staging/rtl8192su/r819xU_phy.c b/drivers/staging/rtl8192su/r819xU_phy.c
index 00497d3..cbc922c 100644
--- a/drivers/staging/rtl8192su/r819xU_phy.c
+++ b/drivers/staging/rtl8192su/r819xU_phy.c
@@ -42,7 +42,7 @@ static u32 RF_CHANNEL_TABLE_ZEBRA[] = {
  *	     and do register read/write
  *   input:  u32	dwBitMask  //taget bit pos in the addr to be modified
  *  output:  none
- *  return:  u32	return the shift bit bit position of the mask
+ *  return:  u32	return the shift bit position of the mask
  * ****************************************************************************/
 u32 rtl8192_CalculateBitShift(u32 dwBitMask)
 {
diff --git a/sound/isa/cs423x/cs4236_lib.c b/sound/isa/cs423x/cs4236_lib.c
index 38835f3..8109b4b 100644
--- a/sound/isa/cs423x/cs4236_lib.c
+++ b/sound/isa/cs423x/cs4236_lib.c
@@ -53,7 +53,7 @@
  *     D7: consumer serial port enable (CS4237B,CS4238B)
  *     D6: channels status block reset (CS4237B,CS4238B)
  *     D5: user bit in sub-frame of digital audio data (CS4237B,CS4238B)
- *     D4: validity bit bit in sub-frame of digital audio data (CS4237B,CS4238B)
+ *     D4: validity bit in sub-frame of digital audio data (CS4237B,CS4238B)
  * 
  *  C5  lower channel status (digital serial data description) (CS4237B,CS4238B)
  *     D7-D6: first two bits of category code
-- 
1.6.0.6



