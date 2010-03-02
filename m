Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0CBXq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:46:28 -0500
Received: from kroah.org ([198.145.64.141]:51634 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab0CBXhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:08 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/36] serial: timberdale: Remove dependancies
Date: Tue,  2 Mar 2010 15:36:37 -0800
Message-Id: <1267573003-782-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

MFD_TIMBERDALE doesn't appear to be defined anywhere. However the code in
question can build happily without platform specifics so remove the check

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index cb935b1..746e070 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1449,7 +1449,6 @@ config SERIAL_BFIN_SPORT3_UART
 
 config SERIAL_TIMBERDALE
 	tristate "Support for timberdale UART"
-	depends on MFD_TIMBERDALE
 	select SERIAL_CORE
 	---help---
 	Add support for UART controller on timberdale.
-- 
1.7.0.1

