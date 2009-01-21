Return-Path: <linux-kernel-owner+w=401wt.eu-S1760570AbZAUNKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760570AbZAUNKm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZAUNKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:10:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58145 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbZAUNKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:10:31 -0500
Date: Wed, 21 Jan 2009 08:10:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Lampersperger Andreas <lampersperger.andreas@heidenhain.de>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: RE: 2.6.24.7-rt26 and 2.6.26.8-rt13
In-Reply-To: <CEE27071B8F0914B91B3076CEB63C2B60725B58E@de01ex08.GLOBAL.JHCN.NET>
Message-ID: <alpine.DEB.1.10.0901210809420.14906@gandalf.stny.rr.com>
References: <1231557759.922.9.camel@localhost.localdomain> <CEE27071B8F0914B91B3076CEB63C2B60725B58E@de01ex08.GLOBAL.JHCN.NET>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 21 Jan 2009, Lampersperger Andreas wrote:

> Hi,
> 
> I'm using kernel 2.6.26.8-rt13 with CONFIG_DYNAMIC_FTRACE=y set.
> When loading a kernel object the following message appear:
> 
> BUG: sleeping function called from invalid context insmod(1370) at include/asm/uaccess_32.h:560
> in_atomic():0 [00000000], irqs_disabled():1
> Pid: 1370, comm: insmod Not tainted 2.6.26.8-rt13-heros5 #8
>  [<c011e13e>] __might_sleep+0xe5/0xea
>  [<c011439a>] ftrace_modify_code+0x22/0xa6
>  [<c0114364>] ? ftrace_test_p6nop+0x0/0xa
>  [<c0162fb4>] __ftrace_update_code+0xed/0x2cf
>  [<c0114364>] ? ftrace_test_p6nop+0x0/0xa
>  [<c0163730>] ftrace_convert_nops+0x57/0x73
>  [<c0163761>] ftrace_init_module+0x15/0x17
>  [<c01491da>] sys_init_module+0x14c9/0x1a7d
>  [<c016d89d>] ? generic_file_aio_read+0x49a/0x4d6
>  [<c0311ef9>] ? sub_preempt_count+0xa2/0xb0
>  [<c02180c4>] ? strpbrk+0x0/0x2b
>  [<c019b7b9>] ? dput+0x34/0xe4
>  [<c0104b31>] sysenter_past_esp+0x6a/0x99
>  =======================
> 
> Is it not possible to use rt-patches and dynamic tracepoints?

No, it should. That is a bug, I'll try to reproduce it, could you send me 
your config.

Thanks,

-- Steve

