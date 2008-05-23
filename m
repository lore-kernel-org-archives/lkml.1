Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbYEWSyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbYEWSyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 14:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYEWSyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 14:54:12 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40953 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbYEWSyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 14:54:11 -0400
Date: Fri, 23 May 2008 11:54:03 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: kristen.c.accardi@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] dock.c remove trailing printk whitespace
Message-ID: <20080523185400.GA4334@tpepper-t42p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dock.c remove trailing printk whitespace

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>

---

I was looking at how docking events are handled these days as I was hoping
to have an event handler automatically run an xrandr script for me to
set up and remove my docking station attached monitor on dock/undock
(which I still haven't figured out how to do or if it's even supported
with my hardware :) and noticed the printk from the dock driver left
trailing whitespace in syslog.  Given the \n this doesn't look like it's
meant to be a field separator...maybe in the past?


diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index fa44fb9..96c542f 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -834,7 +834,7 @@ static int dock_add(acpi_handle handle)
 		goto dock_add_err;
 	}
 
-	printk(KERN_INFO PREFIX "%s \n", ACPI_DOCK_DRIVER_DESCRIPTION);
+	printk(KERN_INFO PREFIX "%s\n", ACPI_DOCK_DRIVER_DESCRIPTION);
 
 	return 0;
 
