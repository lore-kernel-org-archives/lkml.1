Return-Path: <linux-kernel-owner+w=401wt.eu-S1756676AbYHYVNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbYHYVNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 17:13:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYHYVNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 17:13:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:25984 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbYHYVNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 17:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=SLkmW6cbSZ5R2TmSoMwFnYJuzNSUveEkcrnyDAqjHtbnjkoaFKS2kjgqZm0Xmboo48
         VwkYvkkh3QHHuGU+pWPf96LOiofDXUvSum1oIvlI5rdJ+D+XyB9mfKZaM4cvEUJVfCW6
         gRRlEn0drAKMDacVx0hwhvOWuNsETuxqTRF2Q=
Subject: Compile error in latest git v2.6.27-rc4-161-g426e1ea and fixlet
From: Alejandro Riveira =?ISO-8859-1?Q?Fern=E1ndez?= 
	<alejandro.riveira@gmail.com>
Reply-To: alejandro.riveira@gmail.com
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 23:13:33 +0200
Message-Id: <1219698813.21407.4.camel@Varda>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/pci/ca0106/ca0106_main.c:263: error:

v2.6.27-rc4-161-g426e1ea 

fails for me at compile time. Fix included

make -C /home/alex/kernel/linux-2.6 O=/home/alex/kernel/2.6.27/. 
  Using /home/alex/kernel/linux-2.6 as source for kernel
  GEN     /home/alex/kernel/2.6.27/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    /home/alex/kernel/linux-2.6/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
  VDSOSYM arch/x86/vdso/vdso-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syscall-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  CC [M]  sound/pci/ca0106/ca0106_main.o
/home/alex/kernel/linux-2.6/sound/pci/ca0106/ca0106_main.c:263: error:
expected '}' before '{' token
make[5]: *** [sound/pci/ca0106/ca0106_main.o] Error 1
make[4]: *** [sound/pci/ca0106] Error 2
make[3]: *** [sound/pci] Error 2
make[2]: *** [sound] Error 2
make[1]: *** [sub-make] Error 2
make: *** [all] Error 2




diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 03a274b..a7d8966 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -254,7 +254,7 @@ static struct snd_ca0106_details ca0106_chip_details[] = {
 	   .name   = "MSI K8N Diamond MB",
 	   .gpio_type = 2,
 	   .i2c_adc = 1,
-	   .spi_dac = 2 }
+	   .spi_dac = 2 } ,
 	 /* Shuttle XPC SD31P which has an onboard Creative Labs
 	  * Sound Blaster Live! 24-bit EAX
 	  * high-definition 7.1 audio processor".

-- 
The idea that Bill Gates has appeared like a knight in shining armour to
lead all customers out of a mire of technological chaos neatly ignores
the fact that it was he who, by peddling second-rate technology, led
them into it in the first place. 
                                     Douglas Adams

