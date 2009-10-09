Return-Path: <linux-kernel-owner+w=401wt.eu-S1761893AbZJIXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761893AbZJIXUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 19:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761703AbZJIXUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 19:20:32 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:61960 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761645AbZJIXU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 19:20:29 -0400
Date: Fri, 9 Oct 2009 16:17:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
       Dan Williams <dcbw@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       libertas-dev@lists.infradead.org
Subject: [PATCH -next] libertas: depends on CFG80211
Message-Id: <20091009161730.6ae5fe59.randy.dunlap@oracle.com>
In-Reply-To: <20091009190654.741eeffd.sfr@canb.auug.org.au>
References: <20091009190654.741eeffd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACFC4FF.004F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

libertas uses CFG80211 functions so it should depend on that symbol.

drivers/built-in.o: In function `lbs_cfg_free':
(.text+0x9ca93): undefined reference to `wiphy_unregister'
drivers/built-in.o: In function `lbs_cfg_free':
(.text+0x9ca9a): undefined reference to `wiphy_free'
drivers/built-in.o: In function `lbs_cfg_register':
(.text+0x9cb45): undefined reference to `wiphy_register'
drivers/built-in.o: In function `lbs_cfg_alloc':
(.text+0x9cc64): undefined reference to `wiphy_new'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/net/wireless/libertas/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20091009.orig/drivers/net/wireless/libertas/Kconfig
+++ linux-next-20091009/drivers/net/wireless/libertas/Kconfig
@@ -1,6 +1,6 @@
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
-	depends on WLAN_80211
+	depends on WLAN_80211 && CFG80211
 	select WIRELESS_EXT
 	select WEXT_SPY
 	select LIB80211
