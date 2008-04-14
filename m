Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbYDNSMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbYDNSMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 14:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbYDNSMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 14:12:08 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:58377 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760720AbYDNSMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 14:12:06 -0400
Date: Mon, 14 Apr 2008 20:11:40 +0200
From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
To: Adrian Bunk <bunk@kernel.org>
Cc: hskinnemoen@atmel.com, herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
       shannon.nelson@intel.com, dan.j.williams@intel.com
Subject: Re: [2.6 patch] add include/asm-avr32/xor.h
Message-ID: <20080414181140.GA813@Chamillionaire.breakpoint.cc>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
References: <20080414141632.GA6695@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20080414141632.GA6695@cs181133002.pp.htv.fi>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk | 2008-04-14 17:16:32 [+0300]:

>This patch fixes the following compile error with CONFIG_MD_RAID456
>on avr32:
>
><--  snip  -->
>
>...
>  CC [M]  crypto/xor.o
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:23:21: error: asm/xor.h: No such file or directory
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c: In function 'calibrate_xor_blocks':
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: 'XOR_TRY_TEMPLATES' undeclared (first use in this function)
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: (Each undeclared identifier is reported only once
>/home/bunk/linux/kernel-2.6/git/linux-2.6/crypto/xor.c:131: error: for each function it appears in.)
>make[2]: *** [crypto/xor.o] Error 1
>
><--  snip  -->
>
>Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
>---
>601f75e99c076c16e2648f4860cac4fc6ce187ea diff --git a/include/asm-avr32/xor.h b/include/asm-avr32/xor.h
>new file mode 100644
>index 0000000..99c87aa
>--- /dev/null
>+++ b/include/asm-avr32/xor.h
>@@ -0,0 +1,6 @@
>+#ifndef _ASM_XOR_H
>+#define _ASM_XOR_H
>+
>+#include <asm-generic/xor.h>
>+
>+#endif

What about providing <linux/xor.h> which includes the right file from
asm/ or asm-generic/ depending on HAVE_.* ?

Sebastian
