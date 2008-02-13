Return-Path: <linux-kernel-owner+w=401wt.eu-S1764814AbYBMViN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764814AbYBMViN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763523AbYBMVaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:30:25 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50795 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763492AbYBMVaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:30:20 -0500
Date: Wed, 13 Feb 2008 23:30:04 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Sterba <dsterba@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
       jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] #if 0 ipwireless_dump_{hardware,network}_state()
Message-ID: <20080213213004.GU3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch #if 0's the unused ipwireless_dump_{hardware,network}_state().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/char/pcmcia/ipwireless/hardware.c |    2 +-
 drivers/char/pcmcia/ipwireless/hardware.h |    2 --
 drivers/char/pcmcia/ipwireless/network.c  |    2 +-
 drivers/char/pcmcia/ipwireless/network.h  |    3 ---

1aaeb739ce70558e6371c43712c14d7afea2da7e diff --git a/drivers/char/pcmcia/ipwireless/hardware.c b/drivers/char/pcmcia/ipwireless/hardware.c
index 1f978ff..ed59d8e 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.c
+++ b/drivers/char/pcmcia/ipwireless/hardware.c
@@ -354,7 +354,7 @@ struct ipw_rx_packet {
 	unsigned int channel_idx;
 };
 
-#ifdef IPWIRELESS_STATE_DEBUG
+#if 0
 int ipwireless_dump_hardware_state(char *p, size_t limit,
 				   struct ipw_hardware *hw)
 {
diff --git a/drivers/char/pcmcia/ipwireless/hardware.h b/drivers/char/pcmcia/ipwireless/hardware.h
index c83190f..19ce5eb 100644
--- a/drivers/char/pcmcia/ipwireless/hardware.h
+++ b/drivers/char/pcmcia/ipwireless/hardware.h
@@ -58,7 +58,5 @@ void ipwireless_init_hardware_v1(struct ipw_hardware *hw,
 				 void *reboot_cb_data);
 void ipwireless_init_hardware_v2_v3(struct ipw_hardware *hw);
 void ipwireless_sleep(unsigned int tenths);
-int ipwireless_dump_hardware_state(char *p, size_t limit,
-				   struct ipw_hardware *hw);
 
 #endif
diff --git a/drivers/char/pcmcia/ipwireless/network.c b/drivers/char/pcmcia/ipwireless/network.c
index ff35230..7453e10 100644
--- a/drivers/char/pcmcia/ipwireless/network.c
+++ b/drivers/char/pcmcia/ipwireless/network.c
@@ -64,7 +64,7 @@ struct ipw_network {
 };
 
 
-#ifdef IPWIRELESS_STATE_DEBUG
+#if 0
 int ipwireless_dump_network_state(char *p, size_t limit,
 				  struct ipw_network *network)
 {
diff --git a/drivers/char/pcmcia/ipwireless/network.h b/drivers/char/pcmcia/ipwireless/network.h
index b0e1e95..ccacd26 100644
--- a/drivers/char/pcmcia/ipwireless/network.h
+++ b/drivers/char/pcmcia/ipwireless/network.h
@@ -49,7 +49,4 @@ void ipwireless_ppp_close(struct ipw_network *net);
 int ipwireless_ppp_channel_index(struct ipw_network *net);
 int ipwireless_ppp_unit_number(struct ipw_network *net);
 
-int ipwireless_dump_network_state(char *p, size_t limit,
-				  struct ipw_network *net);
-
 #endif

