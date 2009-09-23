Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZIWX6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZIWX6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 19:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbZIWX55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 19:57:57 -0400
Received: from smtp231.iad.emailsrvr.com ([207.97.245.231]:34745 "EHLO
	smtp231.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZIWX54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 19:57:56 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 19:57:55 EDT
From: Oren Laadan <orenl@librato.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@osdl.org>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-api@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>
Subject: [PATCH v18 09/80] Namespaces submenu
Date: Wed, 23 Sep 2009 19:50:49 -0400
Message-Id: <1253749920-18673-10-git-send-email-orenl@librato.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1253749920-18673-1-git-send-email-orenl@librato.com>
References: <1253749920-18673-1-git-send-email-orenl@librato.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Hansen <dave@linux.vnet.ibm.com>

Let's not steal too much space in the 'General Setup' menu.
Take a cue from the cgroups code and create a submenu.

This can go upstream now.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Oren Laadan <orenl@cs.columbia.edu>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 3f7e609..46ee2c8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -664,7 +664,7 @@ config RELAY
 
 	  If unsure, say N.
 
-config NAMESPACES
+menuconfig NAMESPACES
 	bool "Namespaces support" if EMBEDDED
 	default !EMBEDDED
 	help
-- 
1.6.0.4

