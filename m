Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbXA0SeP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbXA0SeP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:34:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbXA0SeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:34:15 -0500
Received: from mout0.freenet.de ([194.97.50.131]:51163 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324AbXA0SeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:34:14 -0500
From: Karsten Wiese <fzu@wemgehoertderstaat.de>
To: Frieder =?utf-8?q?B=C3=BCrzele?= <linux-stuff@arcor.de>
Subject: Re: 2.6.20-rc6-rt2 compile error on x86 -- undefined reference to `send_IPI_mask_bitmask'
Date: Sat, 27 Jan 2007 19:34:42 +0100
User-Agent: KMail/1.9.5
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
References: <45BB3753.9050301@arcor.de>
In-Reply-To: <45BB3753.9050301@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200701271934.43015.fzu@wemgehoertderstaat.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 27. Januar 2007 12:28 schrieb Frieder Bürzele:
> Hi,
> 
> I got the follow while trying to compile 2.6.20-rc6-rt2
> .config attached
> 
> Greetz Frieder
> 
> please CC me
> 
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   GZIP    kernel/config_data.gz
>   IKCFG   kernel/config_data.h
>   CC      kernel/configs.o
>   LD      kernel/built-in.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> arch/i386/kernel/built-in.o: In function 
> `lapic_timer_broadcast':apic.c:(.text+0xccc8): undefined reference to 
> `send_IPI_mask_bitmask'
> make: *** [.tmp_vmlinux1] Error 1

Enabling CONFIG_SMP works around that.

      Karsten
