Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXIYEA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXIYEA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXIYEAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:00:15 -0400
Received: from ozlabs.org ([203.10.76.45]:33101 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbXIYEAN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:00:13 -0400
Subject: [PATCH 2/3] Virtualization config cleanup: move lgeust under
	virtualization menu
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
In-Reply-To: <1190692688.27805.276.camel@localhost.localdomain>
References: <1190692688.27805.276.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 13:59:59 +1000
Message-Id: <1190692799.27805.279.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Move lguest under the virtualization menu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/Kconfig     |    2 --
 drivers/kvm/Kconfig |    6 +++++-
 2 files changed, 5 insertions(+), 3 deletions(-)

===================================================================
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -87,6 +87,4 @@ source "drivers/kvm/Kconfig"
 source "drivers/kvm/Kconfig"
 
 source "drivers/uio/Kconfig"
-
-source "drivers/lguest/Kconfig"
 endmenu
===================================================================
--- a/drivers/kvm/Kconfig
+++ b/drivers/kvm/Kconfig
@@ -45,4 +36,8 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
-endif # VIRTUALIZATION
+# OK, it's a little counter-intuitive to do this, but it puts it neatly under
+# the virtualization menu.
+source drivers/lguest/Kconfig
+
+endif # VIRTUALIZATION



