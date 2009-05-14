Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbZENLQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbZENLQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbZENLQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:16:03 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbZENLQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:16:01 -0400
Date: Thu, 14 May 2009 13:15:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: drivers/serial/Kconfig: .ko is normally not included in kconfig
	help
Message-ID: <20090514111556.GA9347@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


.ko is normally not included in Kconfig help, make it consistent.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

---
commit 3f582fadb61bfcf948609b9fa5d832d2bab098a7
tree c0adf6e1122a15be49c046d1c84f94c6a61ff73c
parent 4d874471a704784cf7e0fe1bf7e9c050d0e1063c
author Pavel <pavel@ucw.cz> Thu, 14 May 2009 13:15:20 +0200
committer Pavel <pavel@ucw.cz> Thu, 14 May 2009 13:15:20 +0200

 drivers/serial/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 343e3a3..472a572 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -860,7 +860,7 @@ config SERIAL_UARTLITE
 	  Say Y here if you want to use the Xilinx uartlite serial controller.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called uartlite.ko.
+	  module will be called uartlite.
 
 config SERIAL_UARTLITE_CONSOLE
 	bool "Support for console on Xilinx uartlite serial port"

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
