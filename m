Return-Path: <linux-kernel-owner+w=401wt.eu-S932586AbZDAOJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbZDAOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 10:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765969AbZDAOF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 10:05:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37770 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765811AbZDAOFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 10:05:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/24] specialix: Auto-load specialix module when device
	opened.
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Date: Wed, 01 Apr 2009 15:06:09 +0100
Message-ID: <20090401140607.22882.1887.stgit@localhost.localdomain>
In-Reply-To: <20090401140241.22882.93477.stgit@localhost.localdomain>
References: <20090401140241.22882.93477.stgit@localhost.localdomain>
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

