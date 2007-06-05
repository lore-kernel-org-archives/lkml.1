Return-Path: <linux-kernel-owner+w=401wt.eu-S932319AbXFETNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbXFETNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759606AbXFETNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:13:42 -0400
Received: from mailfe11.tele2.it ([212.247.155.77]:50020 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759395AbXFETNl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:13:41 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 15:13:40 EDT
X-Cloudmark-Score: 0.000000 []
Message-ID: <4665A7C8.9050707@gmail.com>
Date: Tue, 05 Jun 2007 20:13:28 +0200
From: Massimo Maiurana <maiurana@gmail.com>
User-Agent: Thunderbird 1.5.0.7 (X11/20060909)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] kconfig: fix typos in Makefile
X-Enigmail-Version: 0.94.0.0
OpenPGP: id=7044D601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kxgettext fails generating pot file for um arch due to wrong filenames
and related symlinks in Makefile. Fixed with the patch below.

Signed-off-by: Massimo Maiurana <maiurana@gmail.com>

---
diff -Nru linux/scripts/kconfig/Makefile linux.new/scripts/kconfig/Makefile                                                           
--- linux/scripts/kconfig/Makefile      2007-05-06 16:35:23.000000000 +0200                                                           
+++ linux.new/scripts/kconfig/Makefile  2007-05-11 17:53:17.000000000 +0200                                                           
@@ -27,7 +27,7 @@
           --add-comments --keyword=_ --keyword=N_ \                                                                                  
           --files-from=scripts/kconfig/POTFILES.in \                                                                                 
           --output scripts/kconfig/config.pot                                                                                        
-       $(Q)ln -fs Kconfig_i386 arch/um/Kconfig_arch                                                                                  
+       $(Q)ln -fs Kconfig.i386 arch/um/Kconfig.arch                                                                                  
        $(Q)for i in `ls arch/`; \                                                                                                    
        do \                                                                                                                          
          scripts/kconfig/kxgettext arch/$$i/Kconfig \                                                                                
@@ -38,7 +38,7 @@
          --output scripts/kconfig/linux_raw.pot                                                                                      
        $(Q)msguniq --sort-by-file scripts/kconfig/linux_raw.pot \                                                                    
            --output scripts/kconfig/linux.pot                                                                                        
-       $(Q)rm -f arch/um/Kconfig_arch                                                                                                
+       $(Q)rm -f arch/um/Kconfig.arch                                                                                                
        $(Q)rm -f scripts/kconfig/linux_*.pot scripts/kconfig/config.pot                                                              
                                                                                                                                      
 PHONY += randconfig allyesconfig allnoconfig allmodconfig defconfig                                                                  

-- 
       Massimo Maiurana         massimo<at>ragusa.linux.it
       http://massimo.solira.org       GPG keyID #7044D601

Articolo 11 - L'Italia ripudia la guerra come strumento di offesa
alla libertà degli altri popoli e come mezzo di risoluzione delle
controversie internazionali....

