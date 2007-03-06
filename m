Return-Path: <linux-kernel-owner+w=401wt.eu-S1030337AbXCFWCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030337AbXCFWCd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030314AbXCFWCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:02:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:4786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030337AbXCFWCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:02:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,255,1170662400"; 
   d="scan'208"; a="53995549:sNHT16920621"
Date: Tue, 6 Mar 2007 13:58:45 -0800
From: Mark Gross <mgross@linux.intel.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       mark.gross@intel.com, torvalds@linux-foundation.org
Subject: [PATCH] minor updat to tlclk Kconfig entry
Message-ID: <20070306215845.GA1380@linux.intel.com>
Reply-To: mgross@linux.intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The tlclk driver is going on the MPCBL005 so I need to make the Kconfig
more more generic.  Just some text changes.


--mgross

Signed-off-by: Mark Gross <mark.gross@intel.com>

diff -urN -X linux-2.6.21-rc2/Documentation/dontdiff linux-2.6.21-rc2/drivers/char/Kconfig linux-2.6.21-rc2-tlclk/drivers/char/Kconfig
--- linux-2.6.21-rc2/drivers/char/Kconfig	2007-03-06 13:41:21.000000000 -0800
+++ linux-2.6.21-rc2-tlclk/drivers/char/Kconfig	2007-03-06 13:50:06.000000000 -0800
@@ -1026,16 +1026,17 @@
 source "drivers/char/tpm/Kconfig"
 
 config TELCLOCK
-	tristate "Telecom clock driver for MPBL0010 ATCA SBC"
+	tristate "Telecom clock driver for ATCA SBC"
 	depends on EXPERIMENTAL && X86
 	default n
 	help
-	  The telecom clock device is specific to the MPBL0010 ATCA computer and
-	  allows direct userspace access to the configuration of the telecom clock
-	  configuration settings.  This device is used for hardware synchronization
-	  across the ATCA backplane fabric.  Upon loading, the driver exports a
-	  sysfs directory, /sys/devices/platform/telco_clock, with a number of
-	  files for controlling the behavior of this hardware.
+	  The telecom clock device is specific to the MPCBL0010 and MPCBL0050
+	  ATCA computers and allows direct userspace access to the
+	  configuration of the telecom clock configuration settings.  This
+	  device is used for hardware synchronization across the ATCA backplane
+	  fabric.  Upon loading, the driver exports a sysfs directory,
+	  /sys/devices/platform/telco_clock, with a number of files for
+	  controlling the behavior of this hardware.
 
 endmenu
 
