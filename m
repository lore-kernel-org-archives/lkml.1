Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbYCDVfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbYCDVfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 16:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbYCDVfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 16:35:05 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:26837 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409AbYCDVfD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 16:35:03 -0500
Date: Tue, 4 Mar 2008 13:30:56 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>
Subject: Re: build #405 issue for v2.6.25-rc3-435-g87baa2b in apanel.c:
 undefined reference to `i2c_detach_client'
Message-Id: <20080304133056.f9d025aa.randy.dunlap@oracle.com>
In-Reply-To: <200803042222.32936.toralf.foerster@gmx.de>
References: <200803042222.32936.toralf.foerster@gmx.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2008 22:22:29 +0100 Toralf Förster wrote:

> Hello,
> 
> the build with the attached .config failed, make ends with:
> ...

akpm has a patch queued for this.


> WARNING: modpost: Found 14 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `apanel_detach_client':
> apanel.c:(.text+0x7b55b): undefined reference to `i2c_detach_client'
> drivers/built-in.o: In function `led_update':
> apanel.c:(.text+0x7b592): undefined reference to `i2c_smbus_write_word_data'
> drivers/built-in.o: In function `apanel_probe':
> apanel.c:(.text+0x7b648): undefined reference to `i2c_attach_client'
> apanel.c:(.text+0x7b661): undefined reference to `i2c_smbus_write_word_data'
> apanel.c:(.text+0x7b70d): undefined reference to `i2c_detach_client'
> apanel.c:(.text+0x7b7ae): undefined reference to `i2c_detach_client'
> drivers/built-in.o: In function `apanel_poll':
> apanel.c:(.text+0x7b7ea): undefined reference to `i2c_smbus_read_word_data'
> apanel.c:(.text+0x7b800): undefined reference to `i2c_smbus_write_word_data'
> drivers/built-in.o: In function `apanel_attach_adapter':
> apanel.c:(.text+0x7b8d0): undefined reference to `i2c_probe'
> drivers/built-in.o: In function `apanel_init':
> apanel.c:(.init.text+0x3c1d): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `i801_probe':
> i2c-i801.c:(.devinit.text+0x23c5): undefined reference to `i2c_add_adapter'
> drivers/built-in.o: In function `apanel_cleanup':
> apanel.c:(.exit.text+0x779): undefined reference to `i2c_del_driver'
> drivers/built-in.o: In function `i801_remove':
> i2c-i801.c:(.devexit.text+0x27f): undefined reference to `i2c_del_adapter'
> make: *** [.tmp_vmlinux1] Error 1
> 
> 
> The build was made with :
> $> make mrproper && make rndconfig && make
> 
> Here's the config:

[deleted]

---
~Randy
