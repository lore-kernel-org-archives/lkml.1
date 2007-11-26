Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbXKZXUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbXKZXUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbXKZXSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:18:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbXKZXSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:18:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 4/6] Suspend: Fix comment in main.c
Date: Tue, 27 Nov 2007 00:31:21 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711270025.08128.rjw@sisk.pl>
In-Reply-To: <200711270025.08128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711270031.22305.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Fix a comment in kernel/power/main.c so that it doesn't contain lines
longer that 80 characters.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -242,8 +242,8 @@ static int suspend_enter(suspend_state_t
 }
 
 /**
- *	suspend_devices_and_enter - suspend devices and enter the desired system sleep
- *			  state.
+ *	suspend_devices_and_enter - suspend devices and enter the desired system
+ *				    sleep state.
  *	@state:		  state to enter
  */
 int suspend_devices_and_enter(suspend_state_t state)
