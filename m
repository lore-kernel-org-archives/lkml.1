Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbXK1Afg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbXK1Afg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759922AbXK1AeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:34:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46456 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759886AbXK1AeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:34:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/7] Hibernation: Fix comment in disk.c
Date: Wed, 28 Nov 2007 01:28:18 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711280113.36941.rjw@sisk.pl>
In-Reply-To: <200711280113.36941.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711280128.18716.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a comment in kernel/power/disk.c so that it doesn't contain lines
longer that 80 characters.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -568,8 +568,8 @@ static int software_resume(void)
 
 	if (noresume) {
 		/**
-		 * FIXME: If noresume is specified, we need to find the partition
-		 * and reset it back to normal swap space.
+		 * FIXME: If noresume is specified, we need to find the
+		 * partition and reset it back to normal swap space.
 		 */
 		mutex_unlock(&pm_mutex);
 		return 0;

