Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYJXSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYJXSAq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751198AbYJXSAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 14:00:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:51289 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbYJXSAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 14:00:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,479,1220252400"; 
   d="scan'208";a="631288169"
Date: Fri, 24 Oct 2008 11:00:35 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] memory power in config; show up only when it applies
Message-ID: <20081024175951.GA12789@linux-os.sc.intel.com>
References: <20081023223906.GA26918@linux-os.sc.intel.com> <alpine.LFD.1.10.0810241302130.3056@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0810241302130.3056@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Len,

One more one line patch.

Thanks,
Venki


Repair the config option for I7300_IDLE. The menu will now only show up when
applicable.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

---
 drivers/idle/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/idle/Kconfig
===================================================================
--- linux-2.6.orig/drivers/idle/Kconfig	2008-10-24 09:06:00.000000000 -0700
+++ linux-2.6/drivers/idle/Kconfig	2008-10-24 10:48:09.000000000 -0700
@@ -1,5 +1,6 @@
 
 menu "Memory power savings"
+depends on X86_64
 
 config I7300_IDLE_IOAT_CHANNEL
 	bool
@@ -7,7 +8,6 @@ config I7300_IDLE_IOAT_CHANNEL
 config I7300_IDLE
 	tristate "Intel chipset idle power saving driver"
 	select I7300_IDLE_IOAT_CHANNEL
-	depends on X86_64
 	help
 	  Enable idle power savings with certain Intel server chipsets.
 	  The chipset must have I/O AT support, such as the Intel 7300.
