Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbZCXOIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbZCXOIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757799AbZCXODA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:03:00 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48949 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758098AbZCXOC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:02:59 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 10/30] blackfin: BF538/9 serial uart support
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       torvalds@linux-foundation.org
Date: Tue, 24 Mar 2009 14:03:23 +0000
Message-ID: <20090324140321.12735.55366.stgit@localhost.localdomain>
In-Reply-To: <20090324135930.12735.7827.stgit@localhost.localdomain>
References: <20090324135930.12735.7827.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Enable third UART on BF538/9

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 451b64f..46d4321 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -770,7 +770,7 @@ config UART1_RTS_PIN
 
 config SERIAL_BFIN_UART2
 	bool "Enable UART2"
-	depends on SERIAL_BFIN && (BF54x)
+	depends on SERIAL_BFIN && (BF54x || BF538 || BF539)
 	help
 	  Enable UART2
 

