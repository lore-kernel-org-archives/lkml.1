Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZDFPdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZDFPdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZDFPd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:33:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56952 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755422AbZDFPd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:33:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/27] blackfin: BF538/9 serial uart support
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:32:21 +0100
Message-ID: <20090406163220.12934.36203.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
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
index aa9d3a4..07c03b9 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -770,7 +770,7 @@ config UART1_RTS_PIN
 
 config SERIAL_BFIN_UART2
 	bool "Enable UART2"
-	depends on SERIAL_BFIN && (BF54x)
+	depends on SERIAL_BFIN && (BF54x || BF538 || BF539)
 	help
 	  Enable UART2
 

