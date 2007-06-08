Return-Path: <linux-kernel-owner+w=401wt.eu-S968472AbXFHHlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968472AbXFHHlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938308AbXFHHY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:24:26 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:55180 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938207AbXFHHYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:24:22 -0400
Message-Id: <20070608072234.361737000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:14 -0700
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
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 47/54] IPV4: Correct rp_filter help text.
Content-Disposition: inline; filename=ipv4-correct-rp_filter-help-text.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Dave Jones <davej@redhat.com>

As mentioned in http://bugzilla.kernel.org/show_bug.cgi?id=5015
The helptext implies that this is on by default.
This may be true on some distros (Fedora/RHEL have it enabled
in /etc/sysctl.conf), but the kernel defaults to it off.

Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.21.4.orig/net/ipv4/Kconfig
+++ linux-2.6.21.4/net/ipv4/Kconfig
@@ -43,11 +43,11 @@ config IP_ADVANCED_ROUTER
 	  asymmetric routing (packets from you to a host take a different path
 	  than packets from that host to you) or if you operate a non-routing
 	  host which has several IP addresses on different interfaces. To turn
-	  rp_filter off use:
+	  rp_filter on use:
 
-	  echo 0 > /proc/sys/net/ipv4/conf/<device>/rp_filter
+	  echo 1 > /proc/sys/net/ipv4/conf/<device>/rp_filter
 	  or
-	  echo 0 > /proc/sys/net/ipv4/conf/all/rp_filter
+	  echo 1 > /proc/sys/net/ipv4/conf/all/rp_filter
 
 	  If unsure, say N here.
 

-- 
