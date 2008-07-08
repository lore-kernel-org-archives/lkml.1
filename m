Return-Path: <linux-kernel-owner+w=401wt.eu-S1759804AbYGHXZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbYGHXZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYGHXPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:03 -0400
Received: from gw.goop.org ([64.81.55.164]:51204 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbYGHXOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:46 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 46 of 55] xen: enable PM_SLEEP for CONFIG_XEN
X-Mercurial-Node: 2179d41f754ce83dda8702999e3d1a4b810ca2c2
Message-Id: <2179d41f754ce83dda87.1215554828@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:07:08 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen save/restore requires PM_SLEEP to be set without requiring
SUSPEND or HIBERNATION.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 kernel/power/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -82,7 +82,7 @@
 
 config PM_SLEEP
 	bool
-	depends on SUSPEND || HIBERNATION
+	depends on SUSPEND || HIBERNATION || XEN
 	default y
 
 config SUSPEND


