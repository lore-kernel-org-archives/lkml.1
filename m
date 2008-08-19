Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYHSCoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYHSCoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 22:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYHSCoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 22:44:04 -0400
Received: from mail9.dslextreme.com ([66.51.199.94]:43616 "HELO
	mail9.dslextreme.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752574AbYHSCoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 22:44:01 -0400
Message-ID: <48AA3369.900@gawab.com>
Date: Mon, 18 Aug 2008 19:43:53 -0700
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: lkml <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Michal Januszewski <spock@gentoo.org>,
       Antonino Daplas <adaplas@gmail.com>, Greg KH <gregkh@suse.de>,
       Rafael Wysocki <rjw@sisk.pl>,
       Romano Giannetti <romano.giannetti@gmail.com>,
       Adrian Bunk <bunk@kernel.org>,
       Jeremy Nickurak <kernel-bugs@atrus.rifetech.com>
Subject: Re: Backport hr-tick fix into .25/.26
References: <48A9BDC0.9070800@gawab.com> <20080819003110.GH9914@elte.hu>
In-Reply-To: <20080819003110.GH9914@elte.hu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> hm, the backport of 31656519 is a bit intrusive.
>
> find below is an (untested!) version of it - i havent even build-tested 
> it. Does it work for you? But this is Greg's call really.
>   

I tried to apply it onto 2.6.26.2, but got this build error:

CC arch/x86/kernel/i8253.o
CC kernel/sched.o
CC arch/x86/kernel/pci-nommu.o
kernel/sched.c:537: error: field ‘hrtick_csd’ has incomplete type
kernel/sched.c: In function ‘hrtick_start’:
kernel/sched.c:1080: error: implicit declaration of function 
‘__smp_call_function_single’
CC arch/x86/kernel/tsc_32.o
make[2]: *** [kernel/sched.o] Error 1
make[1]: *** [kernel] Error 2
make[1]: *** Waiting for unfinished jobs....
CC arch/x86/kernel/io_delay.o
CC arch/x86/kernel/rtc.o
CC arch/x86/kernel/trampoline.o

Was I suppose to use a different kernel? (2.6.25[.x] or 2.6.26) I'll try 
2.6.25.15

Anyways, I know it's Greg's call, and I'm just trying to inform him of a 
bug that's been fixed upstream that should be backported.
If he declines, that's ok. I've opened a bug report with Ubuntu. But, it 
would help if I had a patch to show.

Justin Madru
