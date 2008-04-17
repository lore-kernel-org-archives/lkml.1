Return-Path: <linux-kernel-owner+w=401wt.eu-S933460AbYDQBVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbYDQBVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 21:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760100AbYDQBIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 21:08:35 -0400
Received: from sous-sol.org ([216.99.217.87]:58937 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760043AbYDQBIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 21:08:34 -0400
Message-Id: <20080417010340.485289840@sous-sol.org>
References: <20080417010122.148289106@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 18:01:51 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>,
       David S Miller <davem@davemloft.net>
Subject: NET: include <linux/types.h> into linux/ethtool.h for __u* typedef
Content-Disposition: inline; filename=net-include-linux-types.h-into-linux-ethtool.h-for-__u-typedef.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Kirill A. Shutemov <k.shutemov@gmail.com>

Upstream commit: e621e69137b24fdbbe7ad28214e8d81e614c25b7

Signed-off-by: Kirill A. Shutemov <k.shutemov@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 include/linux/ethtool.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -12,6 +12,7 @@
 #ifndef _LINUX_ETHTOOL_H
 #define _LINUX_ETHTOOL_H
 
+#include <linux/types.h>
 
 /* This should work for both 32 and 64 bit userland. */
 struct ethtool_cmd {

-- 
