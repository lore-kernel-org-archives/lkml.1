Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab0BCDqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 22:46:05 -0500
Received: from buzzloop.caiaq.de ([212.112.241.133]:45794 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab0BCDpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 22:45:54 -0500
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Daniel Mack <daniel@caiaq.de>, Jiri Kosina <trivial@kernel.org>,
       Junio C Hamano <gitster@pobox.com>
Subject: [PATCH 08/11] tree-wide: Fix spelling of 'beginning'
Date: Wed,  3 Feb 2010 00:48:24 +0800
Message-Id: <1265129307-18201-8-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265129307-18201-7-git-send-email-daniel@caiaq.de>
References: <1265129307-18201-1-git-send-email-daniel@caiaq.de>
 <1265129307-18201-2-git-send-email-daniel@caiaq.de>
 <1265129307-18201-3-git-send-email-daniel@caiaq.de>
 <1265129307-18201-4-git-send-email-daniel@caiaq.de>
 <1265129307-18201-5-git-send-email-daniel@caiaq.de>
 <1265129307-18201-6-git-send-email-daniel@caiaq.de>
 <1265129307-18201-7-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Junio C Hamano <gitster@pobox.com>
---
 arch/mips/alchemy/common/reset.c |    2 +-
 drivers/scsi/sd.c                |    2 +-
 fs/reiserfs/bitmap.c             |    2 +-
 net/mac80211/mesh_plink.c        |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/mips/alchemy/common/reset.c b/arch/mips/alchemy/common/reset.c
index 4791011..45e6074 100644
--- a/arch/mips/alchemy/common/reset.c
+++ b/arch/mips/alchemy/common/reset.c
@@ -147,7 +147,7 @@ void au1000_restart(char *command)
 	/* Give board a chance to do a hardware reset */
 	board_reset();
 
-	/* Jump to the beggining in case board_reset() is empty */
+	/* Jump to the beginning in case board_reset() is empty */
 	__asm__ __volatile__("jr\t%0"::"r"(0xbfc00000));
 }
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 255da53..5d94772 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2105,7 +2105,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
  *	which is followed by sdaaa.
  *
  *	This is basically 26 base counting with one extra 'nil' entry
- *	at the beggining from the second digit on and can be
+ *	at the beginning from the second digit on and can be
  *	determined using similar method as 26 base conversion with the
  *	index shifted -1 after each digit is computed.
  *
diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index 65c8727..ecc04b5 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -169,7 +169,7 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 			return 0;	// No free blocks in this bitmap
 		}
 
-		/* search for a first zero bit -- beggining of a window */
+		/* search for a first zero bit -- beginning of a window */
 		*beg = reiserfs_find_next_zero_le_bit
 		    ((unsigned long *)(bh->b_data), boundary, *beg);
 
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 0f7c6e6..54e4c8b 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -743,7 +743,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		break;
 	default:
 		/* should not get here, PLINK_BLOCKED is dealt with at the
-		 * beggining of the function
+		 * beginning of the function
 		 */
 		spin_unlock_bh(&sta->lock);
 		break;
-- 
1.6.3.3

