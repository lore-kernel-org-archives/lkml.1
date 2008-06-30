Return-Path: <linux-kernel-owner+w=401wt.eu-S1764286AbYF3UJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764286AbYF3UJa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 16:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYF3UJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 16:09:19 -0400
Received: from khc.piap.pl ([195.187.100.11]:45265 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbYF3UJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 16:09:18 -0400
To: Jeff Garzik <jeff@garzik.org>
Cc: <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] WAN: remove extra help text from HDLC_PPP config option
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 30 Jun 2008 22:09:15 +0200
Message-ID: <m3vdzq4rdg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove extra help text from HDLC_PPP config option.

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d3c2773..8f3ac39 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -154,8 +154,6 @@ config HDLC_PPP
 	help
 	  Generic HDLC driver supporting PPP over WAN connections.
 
-	  It will be replaced by new PPP implementation in Linux 2.6.26.
-
 	  If unsure, say N.
 
 config HDLC_X25
