Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbZDFPfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbZDFPfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZDFPdn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:33:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56959 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755774AbZDFPdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:33:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/27] specialix: Auto-load specialix module when device
	opened.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 06 Apr 2009 17:33:11 +0100
Message-ID: <20090406163310.12934.74980.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
References: <20090406162959.12934.97904.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott James Remnant <scott@canonical.com>

The specialix module is missing the char-major-75-* alias that would
cause it to be auto-loaded when a device of that type is opened.  This
patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/specialix.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 3c67c3d..e72be41 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2365,3 +2365,4 @@ module_init(specialix_init_module);
 module_exit(specialix_exit_module);
 
 MODULE_LICENSE("GPL");
+MODULE_ALIAS_CHARDEV_MAJOR(SPECIALIX_NORMAL_MAJOR);

