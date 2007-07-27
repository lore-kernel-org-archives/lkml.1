Return-Path: <linux-kernel-owner+w=401wt.eu-S938439AbXG0X2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938439AbXG0X2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937682AbXG0X2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:28:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37065 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936443AbXG0X2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:28:21 -0400
Date: Fri, 27 Jul 2007 16:28:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@karaya.com
Subject: Re: UML compile error
Message-Id: <20070727162802.a52307dc.akpm@linux-foundation.org>
In-Reply-To: <46AA75E1.10606@googlemail.com>
References: <46AA75E1.10606@googlemail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jul 2007 00:46:57 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> UML does not compile on current git head. 
> 
> ....
> $ make defconfig ARCH=um
> [..]
> $ make  ARCH=um
> scripts/kconfig/conf -s arch/um/Kconfig
> net/bluetooth/hidp/Kconfig:4:warning: 'select' used by config symbol 'BT_HIDP' refers to undefined symbol 'HID'
> drivers/net/wireless/Kconfig:552:warning: 'select' used by config symbol 'RTL8187' refers to undefined symbol 'EEPROM_93CX6'
>   SYMLINK arch/um/include/kern_constants.h
>   CHK     arch/um/include/uml-config.h
>   UPD     arch/um/include/uml-config.h
>   CC      arch/um/sys-i386/user-offsets.s
>   CHK     arch/um/include/user_constants.h
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/um/kernel/asm-offsets.s
> In file included from include/linux/sched.h:54,
>                  from arch/um/include/sysdep/kernel-offsets.h:2,
>                  from arch/um/kernel/asm-offsets.c:1:
> include/linux/jiffies.h:18:5: warning: "CONFIG_HZ" is not defined
> include/linux/jiffies.h:20:7: warning: "CONFIG_HZ" is not defined
> include/linux/jiffies.h:22:7: warning: "CONFIG_HZ" is not defined
> include/linux/jiffies.h:24:7: warning: "CONFIG_HZ" is not defined
> include/linux/jiffies.h:26:7: warning: "CONFIG_HZ" is not defined
> include/linux/jiffies.h:28:7: warning: "CONFIG_HZ" is not defined
> include/linux/jiffies.h:30:7: warning: "CONFIG_HZ" is not defined

I suspect your build setup broke.  Try `make mrproper' then
have another go.
