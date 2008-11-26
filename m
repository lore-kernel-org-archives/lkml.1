Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbYKZVPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbYKZVPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbYKZVNP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:13:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:50180 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYKZVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PoFmKv5jLWpPRPVBdtG7ChjGSL+d17cP/Z+AErdhE4KUeuhy1XQP7IWYTmBAzhgup8
         4lYGxRJMmhjrV2FbFQ5b1tC2hHPI6UCRU6yP+bFIv73xwD0QDULj/EqT/XAVPwaZJezV
         u0MREZ9TkY5x92yw6HqPRJ+tTMi6VF1UZjg0A=
Subject: [PATCH-mm 6/8] iwlwifi: remove uses of __constant_{endian} helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 13:12:52 -0800
Message-Id: <1227733972.5511.128.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The base versions handle constant folding just fine.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Depends on the byteorder consolidation in -mm.

 drivers/net/wireless/iwlwifi/iwl-3945-commands.h |  134 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-commands.h      |  192 +++++++++++-----------
 2 files changed, 163 insertions(+), 163 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
index 8772d9d..735891a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-commands.h
@@ -220,7 +220,7 @@ struct iwl3945_power_per_rate {
  *
  *****************************************************************************/
 
-#define UCODE_VALID_OK	__constant_cpu_to_le32(0x1)
+#define UCODE_VALID_OK	cpu_to_le32(0x1)
 #define INITIALIZE_SUBTYPE    (9)
 
 /*
@@ -322,42 +322,42 @@ enum {
 
 /* rx_config flags */
 /* band & modulation selection */
-#define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
-#define RXON_FLG_CCK_MSK                __constant_cpu_to_le32(1 << 1)
+#define RXON_FLG_BAND_24G_MSK           cpu_to_le32(1 << 0)
+#define RXON_FLG_CCK_MSK                cpu_to_le32(1 << 1)
 /* auto detection enable */
-#define RXON_FLG_AUTO_DETECT_MSK        __constant_cpu_to_le32(1 << 2)
+#define RXON_FLG_AUTO_DETECT_MSK        cpu_to_le32(1 << 2)
 /* TGg protection when tx */
-#define RXON_FLG_TGG_PROTECT_MSK        __constant_cpu_to_le32(1 << 3)
+#define RXON_FLG_TGG_PROTECT_MSK        cpu_to_le32(1 << 3)
 /* cck short slot & preamble */
-#define RXON_FLG_SHORT_SLOT_MSK          __constant_cpu_to_le32(1 << 4)
-#define RXON_FLG_SHORT_PREAMBLE_MSK     __constant_cpu_to_le32(1 << 5)
+#define RXON_FLG_SHORT_SLOT_MSK          cpu_to_le32(1 << 4)
+#define RXON_FLG_SHORT_PREAMBLE_MSK     cpu_to_le32(1 << 5)
 /* antenna selection */
-#define RXON_FLG_DIS_DIV_MSK            __constant_cpu_to_le32(1 << 7)
-#define RXON_FLG_ANT_SEL_MSK            __constant_cpu_to_le32(0x0f00)
-#define RXON_FLG_ANT_A_MSK              __constant_cpu_to_le32(1 << 8)
-#define RXON_FLG_ANT_B_MSK              __constant_cpu_to_le32(1 << 9)
+#define RXON_FLG_DIS_DIV_MSK            cpu_to_le32(1 << 7)
+#define RXON_FLG_ANT_SEL_MSK            cpu_to_le32(0x0f00)
+#define RXON_FLG_ANT_A_MSK              cpu_to_le32(1 << 8)
+#define RXON_FLG_ANT_B_MSK              cpu_to_le32(1 << 9)
 /* radar detection enable */
-#define RXON_FLG_RADAR_DETECT_MSK       __constant_cpu_to_le32(1 << 12)
-#define RXON_FLG_TGJ_NARROW_BAND_MSK    __constant_cpu_to_le32(1 << 13)
+#define RXON_FLG_RADAR_DETECT_MSK       cpu_to_le32(1 << 12)
+#define RXON_FLG_TGJ_NARROW_BAND_MSK    cpu_to_le32(1 << 13)
 /* rx response to host with 8-byte TSF
 * (according to ON_AIR deassertion) */
-#define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
+#define RXON_FLG_TSF2HOST_MSK           cpu_to_le32(1 << 15)
 
 /* rx_config filter flags */
 /* accept all data frames */
-#define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
+#define RXON_FILTER_PROMISC_MSK         cpu_to_le32(1 << 0)
 /* pass control & management to host */
-#define RXON_FILTER_CTL2HOST_MSK        __constant_cpu_to_le32(1 << 1)
+#define RXON_FILTER_CTL2HOST_MSK        cpu_to_le32(1 << 1)
 /* accept multi-cast */
-#define RXON_FILTER_ACCEPT_GRP_MSK      __constant_cpu_to_le32(1 << 2)
+#define RXON_FILTER_ACCEPT_GRP_MSK      cpu_to_le32(1 << 2)
 /* don't decrypt uni-cast frames */
-#define RXON_FILTER_DIS_DECRYPT_MSK     __constant_cpu_to_le32(1 << 3)
+#define RXON_FILTER_DIS_DECRYPT_MSK     cpu_to_le32(1 << 3)
 /* don't decrypt multi-cast frames */
-#define RXON_FILTER_DIS_GRP_DECRYPT_MSK __constant_cpu_to_le32(1 << 4)
+#define RXON_FILTER_DIS_GRP_DECRYPT_MSK cpu_to_le32(1 << 4)
 /* STA is associated */
-#define RXON_FILTER_ASSOC_MSK           __constant_cpu_to_le32(1 << 5)
+#define RXON_FILTER_ASSOC_MSK           cpu_to_le32(1 << 5)
 /* transfer to host non bssid beacons in associated state */
-#define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
+#define RXON_FILTER_BCON_AWARE_MSK      cpu_to_le32(1 << 6)
 
 /**
  * REPLY_RXON = 0x10 (command, has simple generic response)
@@ -471,9 +471,9 @@ struct iwl3945_ac_qos {
 } __attribute__ ((packed));
 
 /* QoS flags defines */
-#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	__constant_cpu_to_le32(0x01)
-#define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
-#define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
+#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	cpu_to_le32(0x01)
+#define QOS_PARAM_FLG_TGN_MSK		cpu_to_le32(0x02)
+#define QOS_PARAM_FLG_TXOP_TYPE_MSK	cpu_to_le32(0x10)
 
 /* Number of Access Categories (AC) (EDCA), queues 0..3 */
 #define AC_NUM                4
@@ -508,27 +508,27 @@ struct iwl3945_qosparam_cmd {
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
-#define STA_FLG_TX_RATE_MSK		__constant_cpu_to_le32(1 << 2);
-#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1 << 8);
+#define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2);
+#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
 
 /* Use in mode field.  1: modify existing entry, 0: add new station entry */
 #define STA_CONTROL_MODIFY_MSK		0x01
 
 /* key flags __le16*/
-#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x0007)
-#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0000)
-#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x0001)
-#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x0002)
-#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x0003)
+#define STA_KEY_FLG_ENCRYPT_MSK	cpu_to_le16(0x0007)
+#define STA_KEY_FLG_NO_ENC	cpu_to_le16(0x0000)
+#define STA_KEY_FLG_WEP		cpu_to_le16(0x0001)
+#define STA_KEY_FLG_CCMP	cpu_to_le16(0x0002)
+#define STA_KEY_FLG_TKIP	cpu_to_le16(0x0003)
 
 #define STA_KEY_FLG_KEYID_POS	8
-#define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
+#define STA_KEY_FLG_INVALID 	cpu_to_le16(0x0800)
 /* wep key is either from global key (0) or from station info array (1) */
-#define STA_KEY_FLG_WEP_KEY_MAP_MSK  __constant_cpu_to_le16(0x0008)
+#define STA_KEY_FLG_WEP_KEY_MAP_MSK  cpu_to_le16(0x0008)
 
 /* wep key in STA: 5-bytes (0) or 13-bytes (1) */
-#define STA_KEY_FLG_KEY_SIZE_MSK     __constant_cpu_to_le16(0x1000)
-#define STA_KEY_MULTICAST_MSK        __constant_cpu_to_le16(0x4000)
+#define STA_KEY_FLG_KEY_SIZE_MSK     cpu_to_le16(0x1000)
+#define STA_KEY_MULTICAST_MSK        cpu_to_le16(0x4000)
 
 /* Flags indicate whether to modify vs. don't change various station params */
 #define	STA_MODIFY_KEY_MASK		0x01
@@ -666,14 +666,14 @@ struct iwl3945_rx_frame_hdr {
 	u8 payload[0];
 } __attribute__ ((packed));
 
-#define RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
-#define RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
+#define RX_RES_STATUS_NO_CRC32_ERROR	cpu_to_le32(1 << 0)
+#define RX_RES_STATUS_NO_RXE_OVERFLOW	cpu_to_le32(1 << 1)
 
-#define RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
-#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
-#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
-#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
+#define RX_RES_PHY_FLAGS_BAND_24_MSK	cpu_to_le16(1 << 0)
+#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
+#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
+#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		cpu_to_le16(0xf0)
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
 #define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
@@ -733,57 +733,57 @@ struct iwl3945_rx_frame {
 
 /* 1: Use Request-To-Send protocol before this frame.
  * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
-#define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+#define TX_CMD_FLG_RTS_MSK cpu_to_le32(1 << 1)
 
 /* 1: Transmit Clear-To-Send to self before this frame.
  * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
  * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK. */
-#define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+#define TX_CMD_FLG_CTS_MSK cpu_to_le32(1 << 2)
 
 /* 1: Expect ACK from receiving station
  * 0: Don't expect ACK (MAC header's duration field s/b 0)
  * Set this for unicast frames, but not broadcast/multicast. */
-#define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+#define TX_CMD_FLG_ACK_MSK cpu_to_le32(1 << 3)
 
 /* 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
  *    Tx command's initial_rate_index indicates first rate to try;
  *    uCode walks through table for additional Tx attempts.
  * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
  *    This rate will be used for all Tx attempts; it will not be scaled. */
-#define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+#define TX_CMD_FLG_STA_RATE_MSK cpu_to_le32(1 << 4)
 
 /* 1: Expect immediate block-ack.
  * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
-#define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+#define TX_CMD_FLG_IMM_BA_RSP_MASK  cpu_to_le32(1 << 6)
 
 /* 1: Frame requires full Tx-Op protection.
  * Set this if either RTS or CTS Tx Flag gets set. */
-#define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+#define TX_CMD_FLG_FULL_TXOP_PROT_MSK cpu_to_le32(1 << 7)
 
 /* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
  * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
-#define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
-#define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
-#define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
+#define TX_CMD_FLG_ANT_SEL_MSK cpu_to_le32(0xf00)
+#define TX_CMD_FLG_ANT_A_MSK cpu_to_le32(1 << 8)
+#define TX_CMD_FLG_ANT_B_MSK cpu_to_le32(1 << 9)
 
 /* 1: Ignore Bluetooth priority for this frame.
  * 0: Delay Tx until Bluetooth device is done (normal usage). */
-#define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
+#define TX_CMD_FLG_BT_DIS_MSK cpu_to_le32(1 << 12)
 
 /* 1: uCode overrides sequence control field in MAC header.
  * 0: Driver provides sequence control field in MAC header.
  * Set this for management frames, non-QOS data frames, non-unicast frames,
  * and also in Tx command embedded in REPLY_SCAN_CMD for active scans. */
-#define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
+#define TX_CMD_FLG_SEQ_CTL_MSK cpu_to_le32(1 << 13)
 
 /* 1: This frame is non-last MPDU; more fragments are coming.
  * 0: Last fragment, or not using fragmentation. */
-#define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
+#define TX_CMD_FLG_MORE_FRAG_MSK cpu_to_le32(1 << 14)
 
 /* 1: uCode calculates and inserts Timestamp Function (TSF) in outgoing frame.
  * 0: No TSF required in outgoing frame.
  * Set this for transmitting beacons and probe responses. */
-#define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
+#define TX_CMD_FLG_TSF_MSK cpu_to_le32(1 << 16)
 
 /* 1: Driver inserted 2 bytes pad after the MAC header, for (required) dword
  *    alignment of frame's payload data field.
@@ -791,10 +791,10 @@ struct iwl3945_rx_frame {
  * Set this for MAC headers with 26 or 30 bytes, i.e. those with QOS or ADDR4
  * field (but not both).  Driver must align frame data (i.e. data following
  * MAC header) to DWORD boundary. */
-#define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
+#define TX_CMD_FLG_MH_PAD_MSK cpu_to_le32(1 << 20)
 
 /* HCCA-AP - disable duration overwriting. */
-#define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
+#define TX_CMD_FLG_DUR_MSK cpu_to_le32(1 << 25)
 
 /*
  * TX command security control
@@ -1158,9 +1158,9 @@ struct iwl3945_spectrum_notification {
  */
 #define IWL_POWER_VEC_SIZE 5
 
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le32(1 << 0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le32(1 << 2)
-#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le32(1 << 3)
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le32(1 << 0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le32(1 << 2)
+#define IWL_POWER_PCI_PM_MSK			cpu_to_le32(1 << 3)
 struct iwl3945_powertable_cmd {
 	__le32 flags;
 	__le32 rx_data_timeout;
@@ -1278,8 +1278,8 @@ struct iwl3945_ssid_ie {
 } __attribute__ ((packed));
 
 #define PROBE_OPTION_MAX        0x4
-#define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
-#define IWL_GOOD_CRC_TH		__constant_cpu_to_le16(1)
+#define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
+#define IWL_GOOD_CRC_TH		cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
 
 /*
@@ -1379,7 +1379,7 @@ struct iwl3945_scan_cmd {
 } __attribute__ ((packed));
 
 /* Can abort will notify by complete notification with abort status. */
-#define CAN_ABORT_STATUS	__constant_cpu_to_le32(0x1)
+#define CAN_ABORT_STATUS	cpu_to_le32(0x1)
 /* complete notification statuses */
 #define ABORT_STATUS            0x2
 
@@ -1572,8 +1572,8 @@ struct statistics_general {
  * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
  * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
  */
-#define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
-#define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
+#define IWL_STATS_CONF_CLEAR_STATS cpu_to_le32(0x1)	/* see above */
+#define IWL_STATS_CONF_DISABLE_NOTIF cpu_to_le32(0x2)/* see above */
 struct iwl3945_statistics_cmd {
 	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
 } __attribute__ ((packed));
@@ -1593,8 +1593,8 @@ struct iwl3945_statistics_cmd {
  * appropriately so that each notification contains statistics for only the
  * one channel that has just been scanned.
  */
-#define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
-#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
+#define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
+#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         cpu_to_le32(0x8)
 struct iwl3945_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 1fe83d4..7c4ce98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -172,8 +172,8 @@ enum {
 #define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
 #define SEQ_TO_INDEX(s)	((s) & 0xff)
 #define INDEX_TO_SEQ(i)	((i) & 0xff)
-#define SEQ_HUGE_FRAME	__constant_cpu_to_le16(0x4000)
-#define SEQ_RX_FRAME	__constant_cpu_to_le16(0x8000)
+#define SEQ_HUGE_FRAME	cpu_to_le16(0x4000)
+#define SEQ_RX_FRAME	cpu_to_le16(0x8000)
 
 /**
  * struct iwl_cmd_header
@@ -368,7 +368,7 @@ struct iwl5000_tx_power_dbm_cmd {
  *
  *****************************************************************************/
 
-#define UCODE_VALID_OK	__constant_cpu_to_le32(0x1)
+#define UCODE_VALID_OK	cpu_to_le32(0x1)
 #define INITIALIZE_SUBTYPE    (9)
 
 /*
@@ -517,75 +517,75 @@ enum {
 };
 

-#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		__constant_cpu_to_le16(0x1 << 0)
-#define RXON_RX_CHAIN_VALID_MSK			__constant_cpu_to_le16(0x7 << 1)
+#define RXON_RX_CHAIN_DRIVER_FORCE_MSK		cpu_to_le16(0x1 << 0)
+#define RXON_RX_CHAIN_VALID_MSK			cpu_to_le16(0x7 << 1)
 #define RXON_RX_CHAIN_VALID_POS			(1)
-#define RXON_RX_CHAIN_FORCE_SEL_MSK		__constant_cpu_to_le16(0x7 << 4)
+#define RXON_RX_CHAIN_FORCE_SEL_MSK		cpu_to_le16(0x7 << 4)
 #define RXON_RX_CHAIN_FORCE_SEL_POS		(4)
-#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	__constant_cpu_to_le16(0x7 << 7)
+#define RXON_RX_CHAIN_FORCE_MIMO_SEL_MSK	cpu_to_le16(0x7 << 7)
 #define RXON_RX_CHAIN_FORCE_MIMO_SEL_POS	(7)
-#define RXON_RX_CHAIN_CNT_MSK			__constant_cpu_to_le16(0x3 << 10)
+#define RXON_RX_CHAIN_CNT_MSK			cpu_to_le16(0x3 << 10)
 #define RXON_RX_CHAIN_CNT_POS			(10)
-#define RXON_RX_CHAIN_MIMO_CNT_MSK		__constant_cpu_to_le16(0x3 << 12)
+#define RXON_RX_CHAIN_MIMO_CNT_MSK		cpu_to_le16(0x3 << 12)
 #define RXON_RX_CHAIN_MIMO_CNT_POS		(12)
-#define RXON_RX_CHAIN_MIMO_FORCE_MSK		__constant_cpu_to_le16(0x1 << 14)
+#define RXON_RX_CHAIN_MIMO_FORCE_MSK		cpu_to_le16(0x1 << 14)
 #define RXON_RX_CHAIN_MIMO_FORCE_POS		(14)
 
 /* rx_config flags */
 /* band & modulation selection */
-#define RXON_FLG_BAND_24G_MSK           __constant_cpu_to_le32(1 << 0)
-#define RXON_FLG_CCK_MSK                __constant_cpu_to_le32(1 << 1)
+#define RXON_FLG_BAND_24G_MSK           cpu_to_le32(1 << 0)
+#define RXON_FLG_CCK_MSK                cpu_to_le32(1 << 1)
 /* auto detection enable */
-#define RXON_FLG_AUTO_DETECT_MSK        __constant_cpu_to_le32(1 << 2)
+#define RXON_FLG_AUTO_DETECT_MSK        cpu_to_le32(1 << 2)
 /* TGg protection when tx */
-#define RXON_FLG_TGG_PROTECT_MSK        __constant_cpu_to_le32(1 << 3)
+#define RXON_FLG_TGG_PROTECT_MSK        cpu_to_le32(1 << 3)
 /* cck short slot & preamble */
-#define RXON_FLG_SHORT_SLOT_MSK          __constant_cpu_to_le32(1 << 4)
-#define RXON_FLG_SHORT_PREAMBLE_MSK     __constant_cpu_to_le32(1 << 5)
+#define RXON_FLG_SHORT_SLOT_MSK          cpu_to_le32(1 << 4)
+#define RXON_FLG_SHORT_PREAMBLE_MSK     cpu_to_le32(1 << 5)
 /* antenna selection */
-#define RXON_FLG_DIS_DIV_MSK            __constant_cpu_to_le32(1 << 7)
-#define RXON_FLG_ANT_SEL_MSK            __constant_cpu_to_le32(0x0f00)
-#define RXON_FLG_ANT_A_MSK              __constant_cpu_to_le32(1 << 8)
-#define RXON_FLG_ANT_B_MSK              __constant_cpu_to_le32(1 << 9)
+#define RXON_FLG_DIS_DIV_MSK            cpu_to_le32(1 << 7)
+#define RXON_FLG_ANT_SEL_MSK            cpu_to_le32(0x0f00)
+#define RXON_FLG_ANT_A_MSK              cpu_to_le32(1 << 8)
+#define RXON_FLG_ANT_B_MSK              cpu_to_le32(1 << 9)
 /* radar detection enable */
-#define RXON_FLG_RADAR_DETECT_MSK       __constant_cpu_to_le32(1 << 12)
-#define RXON_FLG_TGJ_NARROW_BAND_MSK    __constant_cpu_to_le32(1 << 13)
+#define RXON_FLG_RADAR_DETECT_MSK       cpu_to_le32(1 << 12)
+#define RXON_FLG_TGJ_NARROW_BAND_MSK    cpu_to_le32(1 << 13)
 /* rx response to host with 8-byte TSF
 * (according to ON_AIR deassertion) */
-#define RXON_FLG_TSF2HOST_MSK           __constant_cpu_to_le32(1 << 15)
+#define RXON_FLG_TSF2HOST_MSK           cpu_to_le32(1 << 15)
 

 /* HT flags */
 #define RXON_FLG_CTRL_CHANNEL_LOC_POS		(22)
-#define RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK	__constant_cpu_to_le32(0x1 << 22)
+#define RXON_FLG_CTRL_CHANNEL_LOC_HI_MSK	cpu_to_le32(0x1 << 22)
 
 #define RXON_FLG_HT_OPERATING_MODE_POS		(23)
 
-#define RXON_FLG_HT_PROT_MSK			__constant_cpu_to_le32(0x1 << 23)
-#define RXON_FLG_FAT_PROT_MSK			__constant_cpu_to_le32(0x2 << 23)
+#define RXON_FLG_HT_PROT_MSK			cpu_to_le32(0x1 << 23)
+#define RXON_FLG_FAT_PROT_MSK			cpu_to_le32(0x2 << 23)
 
 #define RXON_FLG_CHANNEL_MODE_POS		(25)
-#define RXON_FLG_CHANNEL_MODE_MSK		__constant_cpu_to_le32(0x3 << 25)
-#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	__constant_cpu_to_le32(0x1 << 25)
-#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		__constant_cpu_to_le32(0x2 << 25)
+#define RXON_FLG_CHANNEL_MODE_MSK		cpu_to_le32(0x3 << 25)
+#define RXON_FLG_CHANNEL_MODE_PURE_40_MSK	cpu_to_le32(0x1 << 25)
+#define RXON_FLG_CHANNEL_MODE_MIXED_MSK		cpu_to_le32(0x2 << 25)
 /* CTS to self (if spec allows) flag */
-#define RXON_FLG_SELF_CTS_EN			__constant_cpu_to_le32(0x1<<30)
+#define RXON_FLG_SELF_CTS_EN			cpu_to_le32(0x1<<30)
 
 /* rx_config filter flags */
 /* accept all data frames */
-#define RXON_FILTER_PROMISC_MSK         __constant_cpu_to_le32(1 << 0)
+#define RXON_FILTER_PROMISC_MSK         cpu_to_le32(1 << 0)
 /* pass control & management to host */
-#define RXON_FILTER_CTL2HOST_MSK        __constant_cpu_to_le32(1 << 1)
+#define RXON_FILTER_CTL2HOST_MSK        cpu_to_le32(1 << 1)
 /* accept multi-cast */
-#define RXON_FILTER_ACCEPT_GRP_MSK      __constant_cpu_to_le32(1 << 2)
+#define RXON_FILTER_ACCEPT_GRP_MSK      cpu_to_le32(1 << 2)
 /* don't decrypt uni-cast frames */
-#define RXON_FILTER_DIS_DECRYPT_MSK     __constant_cpu_to_le32(1 << 3)
+#define RXON_FILTER_DIS_DECRYPT_MSK     cpu_to_le32(1 << 3)
 /* don't decrypt multi-cast frames */
-#define RXON_FILTER_DIS_GRP_DECRYPT_MSK __constant_cpu_to_le32(1 << 4)
+#define RXON_FILTER_DIS_GRP_DECRYPT_MSK cpu_to_le32(1 << 4)
 /* STA is associated */
-#define RXON_FILTER_ASSOC_MSK           __constant_cpu_to_le32(1 << 5)
+#define RXON_FILTER_ASSOC_MSK           cpu_to_le32(1 << 5)
 /* transfer to host non bssid beacons in associated state */
-#define RXON_FILTER_BCON_AWARE_MSK      __constant_cpu_to_le32(1 << 6)
+#define RXON_FILTER_BCON_AWARE_MSK      cpu_to_le32(1 << 6)
 
 /**
  * REPLY_RXON = 0x10 (command, has simple generic response)
@@ -745,9 +745,9 @@ struct iwl_ac_qos {
 } __attribute__ ((packed));
 
 /* QoS flags defines */
-#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	__constant_cpu_to_le32(0x01)
-#define QOS_PARAM_FLG_TGN_MSK		__constant_cpu_to_le32(0x02)
-#define QOS_PARAM_FLG_TXOP_TYPE_MSK	__constant_cpu_to_le32(0x10)
+#define QOS_PARAM_FLG_UPDATE_EDCA_MSK	cpu_to_le32(0x01)
+#define QOS_PARAM_FLG_TGN_MSK		cpu_to_le32(0x02)
+#define QOS_PARAM_FLG_TXOP_TYPE_MSK	cpu_to_le32(0x10)
 
 /* Number of Access Categories (AC) (EDCA), queues 0..3 */
 #define AC_NUM                4
@@ -784,34 +784,34 @@ struct iwl_qosparam_cmd {
 #define	IWL_STATION_COUNT	32 	/* MAX(3945,4965)*/
 #define	IWL_INVALID_STATION 	255
 
-#define STA_FLG_PWR_SAVE_MSK		__constant_cpu_to_le32(1 << 8);
-#define STA_FLG_RTS_MIMO_PROT_MSK	__constant_cpu_to_le32(1 << 17)
-#define STA_FLG_AGG_MPDU_8US_MSK	__constant_cpu_to_le32(1 << 18)
+#define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8);
+#define STA_FLG_RTS_MIMO_PROT_MSK	cpu_to_le32(1 << 17)
+#define STA_FLG_AGG_MPDU_8US_MSK	cpu_to_le32(1 << 18)
 #define STA_FLG_MAX_AGG_SIZE_POS	(19)
-#define STA_FLG_MAX_AGG_SIZE_MSK	__constant_cpu_to_le32(3 << 19)
-#define STA_FLG_FAT_EN_MSK		__constant_cpu_to_le32(1 << 21)
-#define STA_FLG_MIMO_DIS_MSK		__constant_cpu_to_le32(1 << 22)
+#define STA_FLG_MAX_AGG_SIZE_MSK	cpu_to_le32(3 << 19)
+#define STA_FLG_FAT_EN_MSK		cpu_to_le32(1 << 21)
+#define STA_FLG_MIMO_DIS_MSK		cpu_to_le32(1 << 22)
 #define STA_FLG_AGG_MPDU_DENSITY_POS	(23)
-#define STA_FLG_AGG_MPDU_DENSITY_MSK	__constant_cpu_to_le32(7 << 23)
+#define STA_FLG_AGG_MPDU_DENSITY_MSK	cpu_to_le32(7 << 23)
 
 /* Use in mode field.  1: modify existing entry, 0: add new station entry */
 #define STA_CONTROL_MODIFY_MSK		0x01
 
 /* key flags __le16*/
-#define STA_KEY_FLG_ENCRYPT_MSK	__constant_cpu_to_le16(0x0007)
-#define STA_KEY_FLG_NO_ENC	__constant_cpu_to_le16(0x0000)
-#define STA_KEY_FLG_WEP		__constant_cpu_to_le16(0x0001)
-#define STA_KEY_FLG_CCMP	__constant_cpu_to_le16(0x0002)
-#define STA_KEY_FLG_TKIP	__constant_cpu_to_le16(0x0003)
+#define STA_KEY_FLG_ENCRYPT_MSK	cpu_to_le16(0x0007)
+#define STA_KEY_FLG_NO_ENC	cpu_to_le16(0x0000)
+#define STA_KEY_FLG_WEP		cpu_to_le16(0x0001)
+#define STA_KEY_FLG_CCMP	cpu_to_le16(0x0002)
+#define STA_KEY_FLG_TKIP	cpu_to_le16(0x0003)
 
 #define STA_KEY_FLG_KEYID_POS	8
-#define STA_KEY_FLG_INVALID 	__constant_cpu_to_le16(0x0800)
+#define STA_KEY_FLG_INVALID 	cpu_to_le16(0x0800)
 /* wep key is either from global key (0) or from station info array (1) */
-#define STA_KEY_FLG_MAP_KEY_MSK	__constant_cpu_to_le16(0x0008)
+#define STA_KEY_FLG_MAP_KEY_MSK	cpu_to_le16(0x0008)
 
 /* wep key in STA: 5-bytes (0) or 13-bytes (1) */
-#define STA_KEY_FLG_KEY_SIZE_MSK     __constant_cpu_to_le16(0x1000)
-#define STA_KEY_MULTICAST_MSK        __constant_cpu_to_le16(0x4000)
+#define STA_KEY_FLG_KEY_SIZE_MSK     cpu_to_le16(0x1000)
+#define STA_KEY_MULTICAST_MSK        cpu_to_le16(0x4000)
 #define STA_KEY_MAX_NUM		8
 
 /* Flags indicate whether to modify vs. don't change various station params */
@@ -1036,14 +1036,14 @@ struct iwl4965_rx_frame_hdr {
 	u8 payload[0];
 } __attribute__ ((packed));
 
-#define RX_RES_STATUS_NO_CRC32_ERROR	__constant_cpu_to_le32(1 << 0)
-#define RX_RES_STATUS_NO_RXE_OVERFLOW	__constant_cpu_to_le32(1 << 1)
+#define RX_RES_STATUS_NO_CRC32_ERROR	cpu_to_le32(1 << 0)
+#define RX_RES_STATUS_NO_RXE_OVERFLOW	cpu_to_le32(1 << 1)
 
-#define RX_RES_PHY_FLAGS_BAND_24_MSK	__constant_cpu_to_le16(1 << 0)
-#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		__constant_cpu_to_le16(1 << 1)
-#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	__constant_cpu_to_le16(1 << 2)
-#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	__constant_cpu_to_le16(1 << 3)
-#define RX_RES_PHY_FLAGS_ANTENNA_MSK		__constant_cpu_to_le16(0xf0)
+#define RX_RES_PHY_FLAGS_BAND_24_MSK	cpu_to_le16(1 << 0)
+#define RX_RES_PHY_FLAGS_MOD_CCK_MSK		cpu_to_le16(1 << 1)
+#define RX_RES_PHY_FLAGS_SHORT_PREAMBLE_MSK	cpu_to_le16(1 << 2)
+#define RX_RES_PHY_FLAGS_NARROW_BAND_MSK	cpu_to_le16(1 << 3)
+#define RX_RES_PHY_FLAGS_ANTENNA_MSK		cpu_to_le16(0xf0)
 
 #define RX_RES_STATUS_SEC_TYPE_MSK	(0x7 << 8)
 #define RX_RES_STATUS_SEC_TYPE_NONE	(0x0 << 8)
@@ -1174,21 +1174,21 @@ struct iwl4965_rx_mpdu_res_start {
 /* 1: Use RTS/CTS protocol or CTS-to-self if spec allows it
  * before this frame. if CTS-to-self required check
  * RXON_FLG_SELF_CTS_EN status. */
-#define TX_CMD_FLG_RTS_CTS_MSK __constant_cpu_to_le32(1 << 0)
+#define TX_CMD_FLG_RTS_CTS_MSK cpu_to_le32(1 << 0)
 
 /* 1: Use Request-To-Send protocol before this frame.
  * Mutually exclusive vs. TX_CMD_FLG_CTS_MSK. */
-#define TX_CMD_FLG_RTS_MSK __constant_cpu_to_le32(1 << 1)
+#define TX_CMD_FLG_RTS_MSK cpu_to_le32(1 << 1)
 
 /* 1: Transmit Clear-To-Send to self before this frame.
  * Driver should set this for AUTH/DEAUTH/ASSOC-REQ/REASSOC mgmnt frames.
  * Mutually exclusive vs. TX_CMD_FLG_RTS_MSK. */
-#define TX_CMD_FLG_CTS_MSK __constant_cpu_to_le32(1 << 2)
+#define TX_CMD_FLG_CTS_MSK cpu_to_le32(1 << 2)
 
 /* 1: Expect ACK from receiving station
  * 0: Don't expect ACK (MAC header's duration field s/b 0)
  * Set this for unicast frames, but not broadcast/multicast. */
-#define TX_CMD_FLG_ACK_MSK __constant_cpu_to_le32(1 << 3)
+#define TX_CMD_FLG_ACK_MSK cpu_to_le32(1 << 3)
 
 /* For 4965:
  * 1: Use rate scale table (see REPLY_TX_LINK_QUALITY_CMD).
@@ -1196,40 +1196,40 @@ struct iwl4965_rx_mpdu_res_start {
  *    uCode walks through table for additional Tx attempts.
  * 0: Use Tx rate/MCS from Tx command's rate_n_flags field.
  *    This rate will be used for all Tx attempts; it will not be scaled. */
-#define TX_CMD_FLG_STA_RATE_MSK __constant_cpu_to_le32(1 << 4)
+#define TX_CMD_FLG_STA_RATE_MSK cpu_to_le32(1 << 4)
 
 /* 1: Expect immediate block-ack.
  * Set when Txing a block-ack request frame.  Also set TX_CMD_FLG_ACK_MSK. */
-#define TX_CMD_FLG_IMM_BA_RSP_MASK  __constant_cpu_to_le32(1 << 6)
+#define TX_CMD_FLG_IMM_BA_RSP_MASK  cpu_to_le32(1 << 6)
 
 /* 1: Frame requires full Tx-Op protection.
  * Set this if either RTS or CTS Tx Flag gets set. */
-#define TX_CMD_FLG_FULL_TXOP_PROT_MSK __constant_cpu_to_le32(1 << 7)
+#define TX_CMD_FLG_FULL_TXOP_PROT_MSK cpu_to_le32(1 << 7)
 
 /* Tx antenna selection field; used only for 3945, reserved (0) for 4965.
  * Set field to "0" to allow 3945 uCode to select antenna (normal usage). */
-#define TX_CMD_FLG_ANT_SEL_MSK __constant_cpu_to_le32(0xf00)
-#define TX_CMD_FLG_ANT_A_MSK __constant_cpu_to_le32(1 << 8)
-#define TX_CMD_FLG_ANT_B_MSK __constant_cpu_to_le32(1 << 9)
+#define TX_CMD_FLG_ANT_SEL_MSK cpu_to_le32(0xf00)
+#define TX_CMD_FLG_ANT_A_MSK cpu_to_le32(1 << 8)
+#define TX_CMD_FLG_ANT_B_MSK cpu_to_le32(1 << 9)
 
 /* 1: Ignore Bluetooth priority for this frame.
  * 0: Delay Tx until Bluetooth device is done (normal usage). */
-#define TX_CMD_FLG_BT_DIS_MSK __constant_cpu_to_le32(1 << 12)
+#define TX_CMD_FLG_BT_DIS_MSK cpu_to_le32(1 << 12)
 
 /* 1: uCode overrides sequence control field in MAC header.
  * 0: Driver provides sequence control field in MAC header.
  * Set this for management frames, non-QOS data frames, non-unicast frames,
  * and also in Tx command embedded in REPLY_SCAN_CMD for active scans. */
-#define TX_CMD_FLG_SEQ_CTL_MSK __constant_cpu_to_le32(1 << 13)
+#define TX_CMD_FLG_SEQ_CTL_MSK cpu_to_le32(1 << 13)
 
 /* 1: This frame is non-last MPDU; more fragments are coming.
  * 0: Last fragment, or not using fragmentation. */
-#define TX_CMD_FLG_MORE_FRAG_MSK __constant_cpu_to_le32(1 << 14)
+#define TX_CMD_FLG_MORE_FRAG_MSK cpu_to_le32(1 << 14)
 
 /* 1: uCode calculates and inserts Timestamp Function (TSF) in outgoing frame.
  * 0: No TSF required in outgoing frame.
  * Set this for transmitting beacons and probe responses. */
-#define TX_CMD_FLG_TSF_MSK __constant_cpu_to_le32(1 << 16)
+#define TX_CMD_FLG_TSF_MSK cpu_to_le32(1 << 16)
 
 /* 1: Driver inserted 2 bytes pad after the MAC header, for (required) dword
  *    alignment of frame's payload data field.
@@ -1237,14 +1237,14 @@ struct iwl4965_rx_mpdu_res_start {
  * Set this for MAC headers with 26 or 30 bytes, i.e. those with QOS or ADDR4
  * field (but not both).  Driver must align frame data (i.e. data following
  * MAC header) to DWORD boundary. */
-#define TX_CMD_FLG_MH_PAD_MSK __constant_cpu_to_le32(1 << 20)
+#define TX_CMD_FLG_MH_PAD_MSK cpu_to_le32(1 << 20)
 
 /* accelerate aggregation support
  * 0 - no CCMP encryption; 1 - CCMP encryption */
-#define TX_CMD_FLG_AGG_CCMP_MSK __constant_cpu_to_le32(1 << 22)
+#define TX_CMD_FLG_AGG_CCMP_MSK cpu_to_le32(1 << 22)
 
 /* HCCA-AP - disable duration overwriting. */
-#define TX_CMD_FLG_DUR_MSK __constant_cpu_to_le32(1 << 25)
+#define TX_CMD_FLG_DUR_MSK cpu_to_le32(1 << 25)
 

 /*
@@ -2076,10 +2076,10 @@ struct iwl4965_spectrum_notification {
  */
 #define IWL_POWER_VEC_SIZE 5
 
-#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	__constant_cpu_to_le16(1 << 0)
-#define IWL_POWER_SLEEP_OVER_DTIM_MSK		__constant_cpu_to_le16(1 << 2)
-#define IWL_POWER_PCI_PM_MSK			__constant_cpu_to_le16(1 << 3)
-#define IWL_POWER_FAST_PD			__constant_cpu_to_le16(1 << 4)
+#define IWL_POWER_DRIVER_ALLOW_SLEEP_MSK	cpu_to_le16(1 << 0)
+#define IWL_POWER_SLEEP_OVER_DTIM_MSK		cpu_to_le16(1 << 2)
+#define IWL_POWER_PCI_PM_MSK			cpu_to_le16(1 << 3)
+#define IWL_POWER_FAST_PD			cpu_to_le16(1 << 4)
 
 struct iwl_powertable_cmd {
 	__le16 flags;
@@ -2153,8 +2153,8 @@ struct iwl_ct_kill_config {
  *
  *****************************************************************************/
 
-#define SCAN_CHANNEL_TYPE_PASSIVE __constant_cpu_to_le32(0)
-#define SCAN_CHANNEL_TYPE_ACTIVE  __constant_cpu_to_le32(1)
+#define SCAN_CHANNEL_TYPE_PASSIVE cpu_to_le32(0)
+#define SCAN_CHANNEL_TYPE_ACTIVE  cpu_to_le32(1)
 
 /**
  * struct iwl_scan_channel - entry in REPLY_SCAN_CMD channel table
@@ -2205,8 +2205,8 @@ struct iwl_ssid_ie {
 } __attribute__ ((packed));
 
 #define PROBE_OPTION_MAX        	0x14
-#define TX_CMD_LIFE_TIME_INFINITE	__constant_cpu_to_le32(0xFFFFFFFF)
-#define IWL_GOOD_CRC_TH			__constant_cpu_to_le16(1)
+#define TX_CMD_LIFE_TIME_INFINITE	cpu_to_le32(0xFFFFFFFF)
+#define IWL_GOOD_CRC_TH			cpu_to_le16(1)
 #define IWL_MAX_SCAN_SIZE 1024
 
 /*
@@ -2306,7 +2306,7 @@ struct iwl_scan_cmd {
 } __attribute__ ((packed));
 
 /* Can abort will notify by complete notification with abort status. */
-#define CAN_ABORT_STATUS	__constant_cpu_to_le32(0x1)
+#define CAN_ABORT_STATUS	cpu_to_le32(0x1)
 /* complete notification statuses */
 #define ABORT_STATUS            0x2
 
@@ -2568,8 +2568,8 @@ struct statistics_general {
  * STATISTICS_NOTIFICATIONs after received beacons (see below).  This flag
  * does not affect the response to the REPLY_STATISTICS_CMD 0x9c itself.
  */
-#define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
-#define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
+#define IWL_STATS_CONF_CLEAR_STATS cpu_to_le32(0x1)	/* see above */
+#define IWL_STATS_CONF_DISABLE_NOTIF cpu_to_le32(0x2)/* see above */
 struct iwl_statistics_cmd {
 	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
 } __attribute__ ((packed));
@@ -2589,8 +2589,8 @@ struct iwl_statistics_cmd {
  * appropriately so that each notification contains statistics for only the
  * one channel that has just been scanned.
  */
-#define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
-#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
+#define STATISTICS_REPLY_FLG_BAND_24G_MSK         cpu_to_le32(0x2)
+#define STATISTICS_REPLY_FLG_FAT_MODE_MSK         cpu_to_le32(0x8)
 struct iwl_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
@@ -2806,8 +2806,8 @@ struct iwl4965_missed_beacon_notif {
 #define HD_OFDM_ENERGY_TH_IN_INDEX                  (10)
 
 /* Control field in struct iwl_sensitivity_cmd */
-#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	__constant_cpu_to_le16(0)
-#define SENSITIVITY_CMD_CONTROL_WORK_TABLE	__constant_cpu_to_le16(1)
+#define SENSITIVITY_CMD_CONTROL_DEFAULT_TABLE	cpu_to_le16(0)
+#define SENSITIVITY_CMD_CONTROL_WORK_TABLE	cpu_to_le16(1)
 
 /**
  * struct iwl_sensitivity_cmd
@@ -2901,7 +2901,7 @@ struct iwl_cal_xtal_freq {
 	u8 cap_pin2;
 } __attribute__ ((packed));
 
-#define IWL_CALIB_INIT_CFG_ALL	__constant_cpu_to_le32(0xffffffff)
+#define IWL_CALIB_INIT_CFG_ALL	cpu_to_le32(0xffffffff)
 
 struct iwl_calib_cfg_elmnt_s {
 	__le32 is_enable;
-- 
1.6.0.4.1044.g77718


