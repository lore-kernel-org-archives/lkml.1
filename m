Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbZBNAjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbZBNAjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 19:39:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbZBNAjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 19:39:23 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:48958 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbZBNAjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 19:39:22 -0500
Date: Fri, 13 Feb 2009 16:39:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       linville@tuxdriver.com
Subject: [PATCH -next/mmotm/resend/lost] wireless: fix for CONFIG_NL80211=n
Message-Id: <20090213163935.ea924a9a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.499612A6.0054:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add empty function for case of CONFIG_NL80211=n:

net/wireless/scan.c:35: error: implicit declaration of function 'nl80211_send_scan_aborted'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/wireless/nl80211.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20090212.orig/net/wireless/nl80211.h
+++ linux-next-20090212/net/wireless/nl80211.h
@@ -27,6 +27,10 @@ static inline void
 nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
 		       struct net_device *netdev)
 {}
+static inline void nl80211_send_scan_aborted(
+					struct cfg80211_registered_device *rdev,
+					struct net_device *netdev)
+{}
 #endif /* CONFIG_NL80211 */
 
 #endif /* __NET_WIRELESS_NL80211_H */
