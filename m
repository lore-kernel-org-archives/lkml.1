Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXJKPqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXJKPqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 11:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXJKPp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 11:45:56 -0400
Received: from sd-green-bigip-74.dreamhost.com ([208.97.132.74]:35552 "EHLO
	jankymail-a1.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754302AbXJKPpz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 11:45:55 -0400
Date: Thu, 11 Oct 2007 11:44:51 -0400
From: Gustavo Chain <g@0xff.cl>
To: mahamuni ashish <ash_lkp@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Getting problem while building kernel module
Message-ID: <20071011114451.7be331fb@0xff.cl>
In-Reply-To: <546131.52217.qm@web7814.mail.in.yahoo.com>
References: <546131.52217.qm@web7814.mail.in.yahoo.com>
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Thu, 11 Oct 2007 15:53:41 +0100 (BST)
mahamuni ashish <ash_lkp@yahoo.co.in> escribió:

> Hi all,
> I am trying to build the following module and getting
> below specified error.please help me for successful
> compilation
> here is my code(ins.c)
> --------------------------
> #include <linux/init.h>
> #include <linux/module.h>
> #include <linux/kernel.h>
> 
> MODULE_LICENSE("Dual BSD/GPL");
> 
> static int hello_init(void)
> {
> 	printk(KERN_ALERT "Hello, world\n");
> 	return 0;
> }
> 
> static void hello_exit(void)
> {
> 	printk(KERN_ALERT "Goodbye, cruel world\n");
> }
> 
> module_init(hello_init);
> module_exit(hello_exit);
> --------------------------
> [root@localhost device_driver]# make
> 
> gcc -O2 -DMODULE -D__KERNEL__ -isystem 
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include   -c
> -o ins.o ins.c
> 'In file included from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/thread_info.h:16,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/thread_info.h:21,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/preempt.h:9,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/spinlock.h:49,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/capability.h:45,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/sched.h:44,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/module.h:9,
>                  from ins.c:2:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/processor.h:80:
> error: CONFIG_X86_L1_CACHE_SHIFT undeclared here
> (not in a function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/processor.h:80:
> error: requested alignment is not a constant
> In file included from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/sched.h:49,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/module.h:9,
>                  from ins.c:2:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:33:3:
> error: #error You lose.
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:210:31:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:254:46:
> error: division by zero in #if
> In file included from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/sched.h:49,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/module.h:9,
>                  from ins.c:2:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function jiffies_to_msecs:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:259:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:259:
> error: (Each undeclared identifier is reported only
> once
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:259:
> error: for each function it appears in.)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:265:46:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function jiffies_to_usecs:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:270:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:278:46:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function msecs_to_jiffies:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:283:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:291:46:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function usecs_to_jiffies:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:296:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function timespec_to_jiffies:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:315:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:321:
> error: SHIFT_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function jiffies_to_timespec:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:334:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function timeval_to_jiffies:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:356:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:360:
> error: SHIFT_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function jiffies_to_timeval:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:372:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:385:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function jiffies_to_clock_t:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:386:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function clock_t_to_jiffies:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:397:
> error: CONFIG_HZ undeclared (first use in this
> function)
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:416:6:
> error: division by zero in #if
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:
> In function jiffies_64_to_clock_t:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/jiffies.h:417:
> error: CONFIG_HZ undeclared (first use in this
> function)
> In file included from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/rwsem.h:24,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:42,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/sched.h:57,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/module.h:9,
>                  from ins.c:2:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:
> In function __down_read:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:104:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:
> In function __down_write_nested:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:156:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:
> In function __up_read:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:198:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:
> In function __up_write:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:224:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:
> In function __downgrade_write:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/rwsem.h:249:
> error: expected : or ) before KBUILD_BASENAME
> In file included from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/sched.h:57,
>                  from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/module.h:9,
>                  from ins.c:2:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:
> In function down:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:105:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:
> In function down_interruptible:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:130:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:
> In function down_trylock:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:155:
> error: expected : or ) before KBUILD_BASENAME
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:
> In function up:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/semaphore.h:179:
> error: expected : or ) before KBUILD_BASENAME
> In file included from
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/linux/module.h:22,
>                  from ins.c:2:
> /usr/src/kernels/2.6.18-1.2798.fc6-i686/include/asm/module.h:65:2:
> error: #error unknown processor family
> make: *** [ins.o] Error 1
> [root@localhost device_driver]# 
> 
> 
> 
> 
>       Get the freedom to save as many mails as you wish. To know how,
> go to
> http://help.yahoo.com/l/in/yahoo/mail/yahoomail/tools/tools-08.html
> 
> -
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

here's a little tutorial
http://vmlinux.org/jocke/linux/external-modules-2.6.shtml

kbuild do the trick

-- 
Gustavo Chaín Dumit
Alumno de Ingeniería de Ejecución Informática
Pontificia Universidad Católica de Valparaiso
http://aleph.homeunix.com/~gchain
