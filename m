Return-Path: <linux-kernel-owner+w=401wt.eu-S1755940AbYHRWjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940AbYHRWjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYHRWjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:39:08 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:34128 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751811AbYHRWjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:39:07 -0400
Message-ID: <48A9FA05.9000601@lwfinger.net>
Date: Mon, 18 Aug 2008 17:39:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.27-rc2 when cross-building the kernel
References: <48A63D98.3070900@lwfinger.net> <20080818193253.GA30856@uranus.ravnborg.org>
In-Reply-To: <20080818193253.GA30856@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> 
> Can you try do do a "make V=1 modules_install install" and post the
> output up to and including the first call to fixdep.
> 
> Neither of these targets should use fixdep and I assume it is 
> down in firmware/ but lets see.

finger@mtech:/ide1/mtech/wireless-testing> sudo make V=1 
modules_install install
make -f /ide1/mtech/wireless-testing/scripts/Makefile.modinst
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/arch/x86/crypto; cp 
arch/x86/crypto/aes-i586.ko 
/lib/modules/2.6.27-rc2-wl/kernel/arch/x86/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/arch/x86/crypto/aes-i586.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/aead.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/aead.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/aes_generic.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/aes_generic.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/anubis.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/anubis.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/arc4.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/arc4.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/authenc.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/authenc.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/blowfish.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/blowfish.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/cast5.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/cast5.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/cast6.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/cast6.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp crypto/cbc.ko 
/lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/cbc.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/crc32c.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/crc32c.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/crypto_blkcipher.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; 
true /lib/modules/2.6.27-rc2-wl/kernel/crypto/crypto_blkcipher.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/crypto; cp 
crypto/crypto_null.ko /lib/modules/2.6.27-rc2-wl/kernel/crypto ; true 
/lib/modules/2.6.27-rc2-wl/kernel/crypto/crypto_null.ko

-- snipped similar commands that were repeated --

   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/sound/pci/ac97; cp 
sound/pci/ac97/snd-ac97-codec.ko 
/lib/modules/2.6.27-rc2-wl/kernel/sound/pci/ac97 ; true 
/lib/modules/2.6.27-rc2-wl/kernel/sound/pci/ac97/snd-ac97-codec.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/sound/pci; cp 
sound/pci/snd-es1938.ko /lib/modules/2.6.27-rc2-wl/kernel/sound/pci ; 
true /lib/modules/2.6.27-rc2-wl/kernel/sound/pci/snd-es1938.ko
   mkdir -p /lib/modules/2.6.27-rc2-wl/kernel/sound; cp 
sound/soundcore.ko /lib/modules/2.6.27-rc2-wl/kernel/sound ; true 
/lib/modules/2.6.27-rc2-wl/kernel/sound/soundcore.ko
make -f /ide1/mtech/wireless-testing/scripts/Makefile.fwinst 
obj=firmware __fw_modinst
   gcc -Wp,-MD,firmware/.ihex2fw.d -Wall -Wstrict-prototypes -O2 
-fomit-frame-pointer     -o firmware/ihex2fw firmware/ihex2fw.c
/bin/sh: scripts/basic/fixdep: cannot execute binary file
make[1]: *** [firmware/ihex2fw] Error 126
make: *** [_modinst_post] Error 2


As you suspected, it is when building firmware.

Larry
