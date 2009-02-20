Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbZBTTyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbZBTTyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 14:54:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbZBTTyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 14:54:38 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54023 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbZBTTyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 14:54:37 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 20 Feb 2009 20:54:27 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH -next] firedtv: build fix for INPUT=m and DVB_FIREDTV=y
To: linux-devel@vger.kernel.org
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.63c8bdca2465364b@s5r6.in-berlin.de>
Message-ID: <tkrat.56ad7ddd6daac9e1@s5r6.in-berlin.de>
References: <tkrat.265ed076d414bd49@s5r6.in-berlin.de>
 <tkrat.63c8bdca2465364b@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/media/dvb/firewire/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/media/dvb/firewire/Kconfig
===================================================================
--- linux.orig/drivers/media/dvb/firewire/Kconfig
+++ linux/drivers/media/dvb/firewire/Kconfig
@@ -17,6 +17,6 @@ config DVB_FIREDTV_IEEE1394
 	def_bool IEEE1394
 
 config DVB_FIREDTV_INPUT
-	def_bool INPUT
+	def_bool INPUT = y || (INPUT = m && DVB_FIREDTV = m)
 
 endif # DVB_FIREDTV

-- 
Stefan Richter
-=====-==--= --=- =-=--
http://arcgraph.de/sr/

