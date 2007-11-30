Return-Path: <linux-kernel-owner+w=401wt.eu-S1754891AbXK3UvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754891AbXK3UvZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752181AbXK3UvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:51:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbXK3UvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:51:08 -0500
Subject: [PATCH] libertas: select WIRELESS_EXT
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <200711302046.52642.toralf.foerster@gmx.de>
References: <200711302046.52642.toralf.foerster@gmx.de>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 15:45:22 -0500
Message-Id: <1196455522.25869.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-6.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure that libertas selects WIRELESS_EXT, since selecting other stuff
that should depend on WEXT, like IEEE80211, doesn't seem to drag that in
for us.

For 2.6.24 and later.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/Kconfig b/drivers/net/wireless/Kconfig
index 82e5de7..081aead 100644
--- a/drivers/net/wireless/Kconfig
+++ b/drivers/net/wireless/Kconfig
@@ -264,6 +264,7 @@ config IPW2200_DEBUG
 config LIBERTAS
 	tristate "Marvell 8xxx Libertas WLAN driver support"
 	depends on WLAN_80211
+	select WIRELESS_EXT
 	select IEEE80211
 	select FW_LOADER
 	---help---

