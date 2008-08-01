Return-Path: <linux-kernel-owner+w=401wt.eu-S1751536AbYHAO1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbYHAO1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYHAO1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:27:12 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:56998 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494AbYHAO1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:27:11 -0400
Date: Fri, 1 Aug 2008 16:27:12 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Michael Opdenacker <michael@free-electrons.com>,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH 2/6] Container Freezer: Make refrigerator always
 available
Message-ID: <20080801162712.63721e8c@surf>
In-Reply-To: <20080801050700.528446138@us.ibm.com>
References: <20080801050659.924495279@us.ibm.com>
	<20080801050700.528446138@us.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le Thu, 31 Jul 2008 22:07:01 -0700,
Matt Helsley <matthltc@us.ibm.com> a écrit :

> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -5,7 +5,7 @@
>  obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
>  	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
>  	    sysctl.o capability.o ptrace.o timer.o user.o \
> -	    signal.o sys.o kmod.o workqueue.o pid.o \
> +	    signal.o sys.o kmod.o workqueue.o pid.o freezer.o \

I have the impression that the code in kernel/power/process.c was
compiled only if CONFIG_PM_SLEEP was set. Now that the code has been
moved to kernel/freezer.c, it is unconditionnaly compiled in every
kernel. Is that correct ?

If so, is it possible to put this new feature under some
CONFIG_SOMETHING option, for people who care about the kernel size ?

Thanks,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
