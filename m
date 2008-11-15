Return-Path: <linux-kernel-owner+w=401wt.eu-S1757342AbYKOFcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342AbYKOFcW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 00:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754679AbYKOFZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 00:25:29 -0500
Received: from kroah.org ([198.145.64.141]:48130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753511AbYKOFZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 00:25:14 -0500
Date: Fri, 14 Nov 2008 21:23:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>,
       Francois Romieu <romieu@fr.zoreil.com>,
       Edward Hsu <edward_hsu@realtek.com.tw>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 21/22] r8169: select MII in Kconfig
Message-ID: <20081115052356.GV3710@kroah.com>
References: <20081115051732.506914008@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="r8169-select-mii-in-kconfig.patch"
In-Reply-To: <20081115052220.GA3710@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

commit b73724921d906d1642f9f6d054079c6b095903fe upstream.

drivers/built-in.o: In function `rtl8169_gset_xmii':
r8169.c:(.text+0x82259): undefined reference to `mii_ethtool_gset'

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Francois Romieu <romieu@fr.zoreil.com>
Cc: Edward Hsu <edward_hsu@realtek.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2046,6 +2046,7 @@ config R8169
 	tristate "Realtek 8169 gigabit ethernet support"
 	depends on PCI
 	select CRC32
+	select MII
 	---help---
 	  Say Y here if you have a Realtek 8169 PCI Gigabit Ethernet adapter.
 

-- 
