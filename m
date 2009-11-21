Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZKUPRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZKUPRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbZKUPR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:17:29 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:39200 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbZKUPR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:17:26 -0500
Message-ID: <4B080456.10905@simon.arlott.org.uk>
Date: Sat, 21 Nov 2009 15:16:38 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.23 (X11/20090927)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 8/8] cxacru: increment driver version
References: <4B08013B.90403@simon.arlott.org.uk>
In-Reply-To: <4B08013B.90403@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:
  Return an empty string for modulation
    when there is no connection
  Fix sysfs unload race conditions
  Log firmware load process, remove delay
  Add new configuration interface
  Remove cxacru-cf.bin

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
---
 drivers/usb/atm/cxacru.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index 7bd7d39..4d80885 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -5,6 +5,7 @@
  *  Copyright (C) 2004 David Woodhouse, Duncan Sands, Roman Kagan
  *  Copyright (C) 2005 Duncan Sands, Roman Kagan (rkagan % mail ! ru)
  *  Copyright (C) 2007 Simon Arlott
+ *  Copyright (C) 2009 Simon Arlott
  *
  *  This program is free software; you can redistribute it and/or modify it
  *  under the terms of the GNU General Public License as published by the Free
@@ -43,7 +44,7 @@
 #include "usbatm.h"
 
 #define DRIVER_AUTHOR	"Roman Kagan, David Woodhouse, Duncan Sands, Simon Arlott"
-#define DRIVER_VERSION	"0.3"
+#define DRIVER_VERSION	"0.4"
 #define DRIVER_DESC	"Conexant AccessRunner ADSL USB modem driver"
 
 static const char cxacru_driver_name[] = "cxacru";
-- 
1.6.3.3

-- 
Simon Arlott

