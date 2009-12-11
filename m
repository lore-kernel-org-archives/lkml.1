Return-Path: <linux-kernel-owner+w=401wt.eu-S933847AbZLKX27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847AbZLKX27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:28:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762819AbZLKX2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:28:52 -0500
Received: from kroah.org ([198.145.64.141]:50421 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762811AbZLKX2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@linux.vnet.ibm.com>,
       Scott Kilau <Scott.Kilau@digi.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 05/58] jsm: Remove ch_cpstime field
Date: Fri, 11 Dec 2009 15:27:49 -0800
Message-Id: <1260574122-10676-5-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitão <leitao@linux.vnet.ibm.com>

Currently the field jsm_channel->ch_cpstime is defined but never
used, so this patch removes it.

Signed-off-by: Breno Leitão <leitao@linux.vnet.ibm.com>
Cc: Scott Kilau <Scott.Kilau@digi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.5.5

