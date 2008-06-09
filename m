Return-Path: <linux-kernel-owner+w=401wt.eu-S1757137AbYFIHiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbYFIHiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 03:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755027AbYFIHif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 03:38:35 -0400
Received: from mail.netone.net.tr ([193.192.98.182]:42063 "EHLO
	mail.netone.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYFIHie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 03:38:34 -0400
Message-ID: <484CDDEC.7050405@netone.net.tr>
Date: Mon, 09 Jun 2008 10:38:20 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25.4-rt6
References: <1212793171.7695.2.camel@localhost.localdomain>
In-Reply-To: <1212793171.7695.2.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2008 07:35:46.0309 (UTC) FILETIME=[6E3A5B50:01C8CA03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this error message at compile stage. Also it is the same error 
that was on -rt4. -rt3 compiles and runs fine.


VDSOSYM arch/x86/vdso/vdso32-syms.lds
LD arch/x86/vdso/built-in.o
CC kernel/sched.o
kernel/sched.c: In function 'sched_init':
kernel/sched.c:7702: error: implicit declaration of function 
'global_rt_runtime'
make[2]: *** [kernel/sched.o] Error 1
make[1]: *** [kernel] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.25.4'
make: *** [debian/stamp-build-kernel] Error 2
root@tarkane:/usr/src/linux-2.6.25.4#

Steven Rostedt wrote:
> We are pleased to announce the 2.6.25.4-rt6 tree, which can be
> downloaded from the location:
>
>   http://rt.et.redhat.com/download/
>
> Information on the RT patch can be found at:
>
>   http://rt.wiki.kernel.org/index.php/Main_Page
>
> Changes since 2.6.25.4-rt5
>
>   - sched_cpupri hotplug support (Gregory Haskins)
>
>   - sched_cpupri prio count (Gregory Haskins)
>
>   - ftrace hotplug fix (Steven Rostedt)
>
> to build a 2.6.25.4-rt6 tree, the following patches should be applied:
>
>   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
>   http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.4.bz2
>   http://rt.et.redhat.com/download/patch-2.6.25.4-rt6.bz2
>
>
>
> And like always, my RT version of Matt Mackall's ketchup will get this
> for you nicely:
>
>   http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3
>
>
> The broken out patches are also available.
>
>
> -- Steve
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   

