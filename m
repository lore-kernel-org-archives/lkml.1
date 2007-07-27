Return-Path: <linux-kernel-owner+w=401wt.eu-S938042AbXG0WvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938042AbXG0WvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765869AbXG0Wu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:50:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:28897 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765713AbXG0Wu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:50:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=pB6nhP0W8PnGTARf+I0+kVjP4kAUyrUqmh8FYalheR4gsPrTkcoZ6QujxRzufG3sC9VfoWh9OpvZcngbzMciNNy4I6xgqUs63WDQjhKbkcOna4LP4uFchITkIeMzjLDkF4Z7BkLKbXXGRmsk62G1t80XUJENHwU9vsJ569QbtFE=
Message-ID: <46AA75E1.10606@googlemail.com>
Date: Sat, 28 Jul 2007 00:46:57 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: jdike@karaya.com
Subject: UML compile error
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

UML does not compile on current git head. 

....
$ make defconfig ARCH=um
[..]
$ make  ARCH=um
scripts/kconfig/conf -s arch/um/Kconfig
net/bluetooth/hidp/Kconfig:4:warning: 'select' used by config symbol 'BT_HIDP' refers to undefined symbol 'HID'
drivers/net/wireless/Kconfig:552:warning: 'select' used by config symbol 'RTL8187' refers to undefined symbol 'EEPROM_93CX6'
  SYMLINK arch/um/include/kern_constants.h
  CHK     arch/um/include/uml-config.h
  UPD     arch/um/include/uml-config.h
  CC      arch/um/sys-i386/user-offsets.s
  CHK     arch/um/include/user_constants.h
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CC      arch/um/kernel/asm-offsets.s
In file included from include/linux/sched.h:54,
                 from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/jiffies.h:18:5: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:20:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:22:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:24:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:26:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:28:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:30:7: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:33:3: error: #error You lose.
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: warning: "CONFIG_HZ" is not defined
include/linux/jiffies.h:225:31: error: division by zero in #if
include/linux/jiffies.h:225:46: warning: "SHIFT_HZ" is not defined
In file included from arch/um/include/sysdep/kernel-offsets.h:2,
                 from arch/um/kernel/asm-offsets.c:1:
include/linux/sched.h: In function 'dequeue_signal_lock':
include/linux/sched.h:1501: error: implicit declaration of function 'local_irq_save'
include/linux/sched.h:1503: error: implicit declaration of function 'local_irq_restore'
In file included from arch/um/kernel/asm-offsets.c:1:
arch/um/include/sysdep/kernel-offsets.h: In function 'foo':
arch/um/include/sysdep/kernel-offsets.h:20: error: 'struct thread_struct' has no member named 'arch'
In file included from arch/um/include/sysdep/kernel-offsets.h:21,
                 from arch/um/kernel/asm-offsets.c:1:
arch/um/include/common-offsets.h:8: error: 'struct thread_struct' has no member named 'regs'
make[1]: *** [arch/um/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

...

Regards, 

Gabriel C
