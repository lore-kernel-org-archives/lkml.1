Return-Path: <linux-kernel-owner+w=401wt.eu-S2992952AbXDDP1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992952AbXDDP1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 11:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992963AbXDDP1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 11:27:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42734 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992958AbXDDPZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 11:25:47 -0400
Date: Wed, 4 Apr 2007 17:25:48 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       John Feeney <jfeeney@redhat.com>, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [-mm patch] unexport pci_proc_attach_device
Message-ID: <20070404152548.GN27660@stusta.de>
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070402224745.71a25af7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 10:47:45PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc5-mm3:
>...
> +fix-82875-pci-setup.patch
>...
>  Misc
>...


pci_proc_attach_device() no longer has any modular user.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc5-mm4/drivers/pci/proc.c.old	2007-04-04 17:06:04.000000000 +0200
+++ linux-2.6.21-rc5-mm4/drivers/pci/proc.c	2007-04-04 17:08:35.000000000 +0200
@@ -480,7 +480,6 @@
 __initcall(pci_proc_init);
 
 #ifdef CONFIG_HOTPLUG
-EXPORT_SYMBOL(pci_proc_attach_device);
 EXPORT_SYMBOL(pci_proc_detach_bus);
 #endif
 

