Return-Path: <linux-kernel-owner+w=401wt.eu-S1760118AbYC0Rga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760118AbYC0Rga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 13:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755283AbYC0RgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 13:36:23 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:55600 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbYC0RgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 13:36:22 -0400
Date: Thu, 27 Mar 2008 19:36:11 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Douglas Thompson <dougthompson@xmission.com>,
       Tim Small <tim@buttersideup.com>, Greg KH <greg@kroah.com>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: EDAC_I82443BXGX still depends on BROKEN
Message-ID: <20080327173610.GB32200@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It must become very good stuff when it takes Greg more than 8 months to 
brew it...  ;-)


commit 28f96eeafc89643d411d54c258788a8573576127
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Jul 19 01:49:45 2007 -0700

    drivers/edac-new-i82443bxgz-mc-driver: mark as broken
    
    It will claim the PCI devices from under intel_agp.ko's feet.  Greg is brewing
    some fix for that.
    
    Cc: Douglas Thompson <dougthompson@xmission.com>
    Cc: Tim Small <tim@buttersideup.com>
    Cc: Greg KH <greg@kroah.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index b56e478..e8c4a2b 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -76,6 +76,7 @@ config EDAC_E752X
 config EDAC_I82443BXGX
 	tristate "Intel 82443BX/GX (440BX/GX)"
 	depends on EDAC_MM_EDAC && PCI && X86_32
+	depends on BROKEN
 	help
 	  Support for error detection and correction on the Intel
 	  82443BX/GX memory controllers (440BX/GX chipsets).


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

