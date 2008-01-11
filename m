Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbYAKLyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbYAKLyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYAKLy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:54:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:59857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYAKLyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:54:24 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org
Subject: Re: Make the 32 bit Frame Pointer backtracer fall back to traditional
References: <20080109220508.686bbda4@laptopd505.fenrus.org>
	<alpine.LFD.1.00.0801100816450.3148@woody.linux-foundation.org>
	<20080110203519.573567b7@laptopd505.fenrus.org>
From: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Date: Fri, 11 Jan 2008 12:54:17 +0100
In-Reply-To: <20080110203519.573567b7@laptopd505.fenrus.org> (Arjan van de Ven's message of "Thu\, 10 Jan 2008 20\:35\:19 -0800")
Message-ID: <87d4s8mvbq.fsf@goat.lan>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V01U2FsdGVkX19OXMPHHarXggZeUDlI0gEw4vFnYptLp1mlCOH
 +vcLoV5M1YstXYjxs24jnykkiA+2MX5oWlUBX0JPRoHSVZuXR5
 IkvUEPo6oHRGbuBiyz3wA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> I coded it, it's not all that bad, the output looks like:
>
> Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #17
>  [<c0405d6c>] show_trace_log_lvl+0x1a/0x2f
>  [<c04066d6>] show_trace+0x12/0x14  
>  [<c0406f47>] dump_stack+0x6a/0x70
>  [<e01f6028>] backtrace_test_timer+0x23/0x25 [backtracetest]
>  [<c0426f07>] run_timer_softirq+0x11b/0x17c
>  [<e01f6005>] .backtrace_test_timer+0x0/0x25 [backtracetest]
>  [<c043b2e0>] .trace_hardirqs_on+0x101/0x13b
>  [<e01f6005>] .backtrace_test_timer+0x0/0x25 [backtracetest]
>  [<c04243ac>] __do_softirq+0x42/0x94
>  [<c04070a0>] do_softirq+0x50/0xb6
>  [<c0453f3c>] .handle_edge_irq+0x0/0xfa
>  [<c04242a9>] irq_exit+0x37/0x67
>  [<c04071a0>] do_IRQ+0x9a/0xaf
>  [<c04057da>] common_interrupt+0x2e/0x34
>  [<c041007b>] .write_watchdog_counter32+0x5/0x48
>  [<c0523371>] .acpi_idle_enter_simple+0x167/0x1da
>  [<c05807fe>] cpuidle_idle_call+0x52/0x78
>  [<c04034f3>] cpu_idle+0x46/0x60
>  [<c05fbbd3>] rest_init+0x43/0x45
>  [<c070aa3d>] start_kernel+0x279/0x27f
>  [<c070a327>] .unknown_bootoption+0x0/0x1a4
>  =======================
>
> where I used a "." to indicate potentially-unreliable (this I'm not
> very happy with, but I can print anything I want on either side of
> the function; ideas welcome).

Maybe question marks?

Regards, Olaf.
