Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYI2WZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYI2WZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYI2WZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 18:25:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYI2WZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 18:25:19 -0400
Date: Mon, 29 Sep 2008 18:24:23 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [patch] xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN
Message-ID: <20080929182423.268c4283@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Ebbert <cebbert@redhat.com>

xen: make CONFIG_XEN_SAVE_RESTORE depend on CONFIG_XEN

Xen options need to depend on XEN.
Also, add newline at end of file.

Without this patch you need to disable CONFIG_PM in order to
disable CPU hotplugging.

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

---

Index: linux-2.6.26.noarch/arch/x86/xen/Kconfig
===================================================================
--- linux-2.6.26.noarch.orig/arch/x86/xen/Kconfig
+++ linux-2.6.26.noarch/arch/x86/xen/Kconfig
@@ -26,5 +26,5 @@ config XEN_MAX_DOMAIN_MEMORY
 
 config XEN_SAVE_RESTORE
        bool
-       depends on PM
-       default y
\ No newline at end of file
+       depends on XEN && PM
+       default y
