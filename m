Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960Ab0CMAUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:33 -0500
Received: from kroah.org ([198.145.64.141]:60630 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934863Ab0CMATu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:50 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:07 2010
Message-Id: <20100313001507.449548684@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Huewe <peterhuewe@gmx.de>, Simon Horman <horms@verge.net.au>
Subject: [patch 026/123] Staging: wlan-ng: Add select WEXT_PRIV to Kconfig to prevent build failure
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Peter Huewe <peterhuewe@gmx.de>

commit 8a8e29752dfdba014b866d3c587d3409e57263dd upstream.

Without WEXT_PRIV set the p80211wext.c fails to build due to unknown fields in
the iw_handler_def struct.
Those fields are enclosed in WEXT_PRIV conditionals in the prototype
of iw_handler_def in include/net/iw_handler.h

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/wlan-ng/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/wlan-ng/Kconfig
+++ b/drivers/staging/wlan-ng/Kconfig
@@ -1,6 +1,7 @@
 config PRISM2_USB
 	tristate "Prism2.5/3 USB driver"
 	depends on WLAN && USB && WIRELESS_EXT
+	select WEXT_PRIV
 	default n
 	---help---
 	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of


