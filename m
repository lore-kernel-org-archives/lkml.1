Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbXLEExB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbXLEExB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 23:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751216AbXLEEww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 23:52:52 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:63493 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXLEEww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 23:52:52 -0500
Date: Tue, 4 Dec 2007 20:51:10 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: jochen@scram.de, akpm <akpm@linux-foundation.org>
Subject: [PATCH] dio: fix kernel-doc notation
Message-Id: <20071204205110.4c660a2f.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc in drivers/dio/ so that it is formatted correctly
and the parameter names match the function parameters.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/dio/dio-driver.c |   70 +++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 36 deletions(-)

--- linux-2.6.24-rc4.orig/drivers/dio/dio-driver.c
+++ linux-2.6.24-rc4/drivers/dio/dio-driver.c
@@ -15,16 +15,15 @@
 #include <linux/dio.h>
 
 
-	/**
-	 *  dio_match_device - Tell if a DIO device structure has a matching
-	 *                     DIO device id structure
-	 *  @ids: array of DIO device id structures to search in
-	 *  @dev: the DIO device structure to match against
-	 *
-	 *  Used by a driver to check whether a DIO device present in the
-	 *  system is in its list of supported devices. Returns the matching
-	 *  dio_device_id structure or %NULL if there is no match.
-	 */
+/**
+ *  dio_match_device - Tell if a DIO device structure has a matching DIO device id structure
+ *  @ids: array of DIO device id structures to search in
+ *  @d: the DIO device structure to match against
+ *
+ *  Used by a driver to check whether a DIO device present in the
+ *  system is in its list of supported devices. Returns the matching
+ *  dio_device_id structure or %NULL if there is no match.
+ */
 
 const struct dio_device_id *
 dio_match_device(const struct dio_device_id *ids,
@@ -66,13 +65,13 @@ static int dio_device_probe(struct devic
 }
 
 
-	/**
-	 *  dio_register_driver - register a new DIO driver
-	 *  @drv: the driver structure to register
-	 *
-	 *  Adds the driver structure to the list of registered drivers
-	 *  Returns zero or a negative error value.
-	 */
+/**
+ *  dio_register_driver - register a new DIO driver
+ *  @drv: the driver structure to register
+ *
+ *  Adds the driver structure to the list of registered drivers
+ *  Returns zero or a negative error value.
+ */
 
 int dio_register_driver(struct dio_driver *drv)
 {
@@ -85,15 +84,15 @@ int dio_register_driver(struct dio_drive
 }
 
 
-	/**
-	 *  dio_unregister_driver - unregister a DIO driver
-	 *  @drv: the driver structure to unregister
-	 *
-	 *  Deletes the driver structure from the list of registered DIO drivers,
-	 *  gives it a chance to clean up by calling its remove() function for
-	 *  each device it was responsible for, and marks those devices as
-	 *  driverless.
-	 */
+/**
+ *  dio_unregister_driver - unregister a DIO driver
+ *  @drv: the driver structure to unregister
+ *
+ *  Deletes the driver structure from the list of registered DIO drivers,
+ *  gives it a chance to clean up by calling its remove() function for
+ *  each device it was responsible for, and marks those devices as
+ *  driverless.
+ */
 
 void dio_unregister_driver(struct dio_driver *drv)
 {
@@ -101,16 +100,15 @@ void dio_unregister_driver(struct dio_dr
 }
 
 
-	/**
-	 *  dio_bus_match - Tell if a DIO device structure has a matching DIO
-	 *                  device id structure
-	 *  @ids: array of DIO device id structures to search in
-	 *  @dev: the DIO device structure to match against
-	 *
-	 *  Used by a driver to check whether a DIO device present in the
-	 *  system is in its list of supported devices. Returns the matching
-	 *  dio_device_id structure or %NULL if there is no match.
-	 */
+/**
+ *  dio_bus_match - Tell if a DIO device structure has a matching DIO device id structure
+ *  @dev: the DIO device structure to match against
+ *  @drv: the &device_driver that points to the array of DIO device id structures to search
+ *
+ *  Used by a driver to check whether a DIO device present in the
+ *  system is in its list of supported devices. Returns the matching
+ *  dio_device_id structure or %NULL if there is no match.
+ */
 
 static int dio_bus_match(struct device *dev, struct device_driver *drv)
 {
