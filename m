Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbZCVUoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbZCVUoq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 16:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZCVUoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 16:44:37 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:52663 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbZCVUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 16:44:37 -0400
Subject: [PATCH] staging: document that the wifi drivers are pointless
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 21:44:31 +0100
Message-Id: <1237754671.19647.7.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All these drivers are pointless -- people shouldn't work on them.
They have replacements or need to be integrated with the proper
wireless work or into other, existing, driver infrastructure.
Some people already started cleaning up the otus driver, despite
ar9170, because the staging drivers are not documented as being
pointless.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I thought there was supposed to be a staging list now... doesn't seem to
have arrived in MAINTAINERS.

 drivers/staging/otus/TODO      |    7 +++----
 drivers/staging/rt2860/TODO    |    4 ++--
 drivers/staging/rt2870/TODO    |    9 ++++++++-
 drivers/staging/wlan-ng/README |    4 +++-
 4 files changed, 16 insertions(+), 8 deletions(-)

--- wireless-testing.orig/drivers/staging/otus/TODO	2009-03-22 10:31:36.000000000 +0100
+++ wireless-testing/drivers/staging/otus/TODO	2009-03-22 10:31:37.000000000 +0100
@@ -1,8 +1,7 @@
 TODO:
-	- checkpatch.pl cleanups
-	- sparse cleanups
-	- port to in-kernel 80211 stack
-	- proper network developer maintainer
+	Any functionality in this driver should be integrated
+	into the ar9170 driver that is under development on the
+	linux-wireless mailing list.
 
 Please send any patches to Greg Kroah-Hartman <greg@kroah.com> and
 Luis Rodriguez <Luis.Rodriguez@Atheros.com> and the
--- wireless-testing.orig/drivers/staging/rt2860/TODO	2009-03-22 10:31:43.000000000 +0100
+++ wireless-testing/drivers/staging/rt2860/TODO	2009-03-22 10:34:12.000000000 +0100
@@ -1,6 +1,6 @@
 I'm hesitant to add a TODO file here, as the wireless developers would
 really have people help them out on the "clean" rt2860 driver that can
-be found at the rt2860.sf.net site.
+be found at the http://rt2x00.serialmonkey.com/ site.
 
 But, if you wish to clean up this driver instead, here's a short list of
 things that need to be done to get it into a more mergable shape:
@@ -8,7 +8,7 @@ things that need to be done to get it in
 TODO:
 	- checkpatch.pl clean
 	- sparse clean
-	- port to in-kernel 80211 stack
+	- port to in-kernel 80211 stack and common rt2x00 infrastructure
 	- remove reading from /etc/ config files
 	- review by the wireless developer community
 
--- wireless-testing.orig/drivers/staging/rt2870/TODO	2009-03-22 10:31:57.000000000 +0100
+++ wireless-testing/drivers/staging/rt2870/TODO	2009-03-22 10:39:55.000000000 +0100
@@ -1,7 +1,14 @@
+I'm hesitant to add a TODO file here, as the wireless developers would
+really have people help them out on the "clean" rt2870 driver that can
+be found at the http://rt2x00.serialmonkey.com/ site.
+
+But, if you wish to clean up this driver instead, here's a short list of
+things that need to be done to get it into a more mergable shape:
+
 TODO:
 	- checkpatch.pl clean
 	- sparse clean
-	- port to in-kernel 80211 stack
+	- port to in-kernel 80211 stack and common rt2x00 infrastructure
 	- remove reading from /etc/ config files
 	- review by the wireless developer community
 
--- wireless-testing.orig/drivers/staging/wlan-ng/README	2009-03-22 10:34:25.000000000 +0100
+++ wireless-testing/drivers/staging/wlan-ng/README	2009-03-22 10:34:32.000000000 +0100
@@ -4,4 +4,6 @@ TODO:
 	- Lindent cleanups
 	- move to use the in-kernel wireless stack
 
-Please send all patches to Greg Kroah-Hartman <greg@kroah.com>
+Please send any patches or complaints about this driver to Greg
+Kroah-Hartman <greg@kroah.com> and don't bother the upstream wireless
+kernel developers about it, they want nothing to do with it.


