Return-Path: <linux-kernel-owner+w=401wt.eu-S967212AbXG3Rw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967212AbXG3Rw5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbXG3Rws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:52:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:61383 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967075AbXG3Rwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=qPTz8J3DLp1i9Pt+2F1Fa9Z+t/TBtniubQ7oxijV+0c6snwfQAav4hFhbKDfsfH9aJSHpDi7XLyTxZNmURLAOj+rq/mxa8U/H8uPbB0o9NG3qQhazzXBJ8u5yorkfE9llFQ3Hmy3tRyZMpxqz9M4/6Bo6Tyy6h8mEzIIuVxU8BQ=
Message-ID: <46AE2459.7080905@googlemail.com>
Date: Mon, 30 Jul 2007 19:48:09 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, J.E.J.Bottomley@HansenPartnership.com
Subject: Section mismatch warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam ,

I get this warnings with a randconfig ( http://194.231.229.228/git-current/randconfig-auto-36 ) :


...

WARNING: vmlinux.o(.text+0xeaf7): Section mismatch: reference to .init.text:init_gdt (between 'voyager_smp_prepare_boot_cpu' and 'smp_vic_cmn_interrupt')
WARNING: vmlinux.o(.text+0x104e3): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x1050a): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10510): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10517): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x1054a): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x1055b): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10765): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10778): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x107b6): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x107c9): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x1090e): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10935): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10944): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x10951): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x109aa): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x109b4): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x109ba): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x109c1): Section mismatch: reference to .init.data:eprom_buf (between 'voyager_cat_init' and 'twofish_enc_blk')
WARNING: vmlinux.o(.text+0x109e4): Section mismatch: reference to .init.data: (between 'voyager_cat_init' and 'twofish_enc_blk')


...

With the same config I see this warnings as well but I think this is a different problem.

...

arch/i386/mach-voyager/voyager_cat.c: In function 'voyager_cat_init':
arch/i386/mach-voyager/voyager_cat.c:685: warning: comparison is always false due to limited range of data type
arch/i386/mach-voyager/voyager_cat.c:755: warning: comparison is always false due to limited range of data type

...


Regards,

Gabriel
