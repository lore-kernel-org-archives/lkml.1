Return-Path: <linux-kernel-owner+w=401wt.eu-S1763835AbYD0UHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763835AbYD0UHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761388AbYD0UHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:07:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:32061 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbYD0UHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:07:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:user-agent:mime-version:content-type:from;
        b=A6bqVWwg8mMMYjJsFI9SlfeVxO4mO/jyPULrz/pBC1v/T3RHG3ONsAKRGJcflgdMxInRMZIszdu3GDEDPyJTuJsSeITiLCGsIUuk+AEmAfB9hdVIio5LTbKWlVeDw60P4wVmVAl1oRkf4ALD+9/2J80+bNl5KEdWlM7rAryg4N8=
Date: Sun, 27 Apr 2008 22:07:40 +0200 (CEST)
To: Andrew Morton <akpm@linux-foundation.org>
cc: Shaohua Li <shaohua.li@intel.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <andi@firstfloor.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       trivial@kernel.org
Subject: [PATCH][Resend] PCI Express ASPM support should default to 'No'
Message-ID: <alpine.LNX.1.00.0804272159520.2352@dragon.funnycrock.com>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
From: Jesper Juhl <jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesper Juhl <jesper.juhl@gmail.com>

[This patch was previously submitted  23 April 2008 00:28]

Andrew; if you could merge this in -mm it would be good, otherwise I'll 
just queue it up in the trivial tree for the next merge window.


Running 'make oldconfig' I just noticed that PCIEASPM defaults to 
'y' in Kconfig even though the feature is experimental and the 
help text recommends that if you are unsure you say 'n'.
It seems to me that this really should default to 'n', not 'y'.
The following patch makes that change. Please consider merging.

Jesse Barnes commented on the patch that it "Seem reasonable".
Shaohua Li also commented saying "Ok, I'm fine with the patch."

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
index 25b04fb..5a0c6ad 100644
--- a/drivers/pci/pcie/Kconfig
+++ b/drivers/pci/pcie/Kconfig
@@ -33,7 +33,7 @@ source "drivers/pci/pcie/aer/Kconfig"
 config PCIEASPM
 	bool "PCI Express ASPM support(Experimental)"
 	depends on PCI && EXPERIMENTAL && PCIEPORTBUS
-	default y
+	default n
 	help
 	  This enables PCI Express ASPM (Active State Power Management) and
 	  Clock Power Management. ASPM supports state L0/L0s/L1.


