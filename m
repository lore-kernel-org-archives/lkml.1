Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab0BHK2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:28:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48788 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755066Ab0BHK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:28:30 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] timberdale: Remove dependancies
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 08 Feb 2010 10:03:58 +0000
Message-ID: <20100208100353.2633.42797.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MFD_TIMBERDALE doesn't appear to be defined anywhere. However the code in
question can build happily without platform specifics so remove the check

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/serial/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 00806f2..45989e4 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1466,7 +1466,6 @@ config SERIAL_BFIN_SPORT3_UART
 
 config SERIAL_TIMBERDALE
 	tristate "Support for timberdale UART"
-	depends on MFD_TIMBERDALE
 	select SERIAL_CORE
 	---help---
 	Add support for UART controller on timberdale.

