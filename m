Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZI2SRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZI2SRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbZI2SRC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:17:02 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:55967 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbZI2SQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:16:59 -0400
From: Breno Leitao <leitao@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Scott.Kilau@digi.com, greg@kroah.com
Subject: [PATCH 3/5] jsm: Remove ch_cpstime field
Date: Tue, 29 Sep 2009 15:16:57 -0300
Message-Id: <70ba6cca73bab63741a4f923f7f0bd38c51b1d5d.1254247209.git.leitao@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
In-Reply-To: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
References: <cover.1254247209.git.leitao@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the field jsm_channel->ch_cpstime is defined but never
used, so this patch removes it.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
---
 drivers/serial/jsm/jsm.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/jsm/jsm.h b/drivers/serial/jsm/jsm.h
index d413e4a..8c14351 100644
--- a/drivers/serial/jsm/jsm.h
+++ b/drivers/serial/jsm/jsm.h
@@ -206,8 +206,6 @@ struct jsm_channel {
 
 	u64		ch_close_delay;	/* How long we should drop RTS/DTR for */
 
-	u64		ch_cpstime;	/* Time for CPS calculations	*/
-
 	tcflag_t	ch_c_iflag;	/* channel iflags		*/
 	tcflag_t	ch_c_cflag;	/* channel cflags		*/
 	tcflag_t	ch_c_oflag;	/* channel oflags		*/
-- 
1.6.0.4

