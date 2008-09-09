Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYIIXaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYIIXaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYIIXao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:30:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36552 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbYIIXao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:30:44 -0400
Message-ID: <48C706B3.4070409@redhat.com>
Date: Tue, 09 Sep 2008 19:28:51 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       April Tsui <aprilla@gmail.com>
Subject: Re: [19.666764] Disabling IRQ #23
References: <dd18b0c30809091208t2821334dw60b592aac34e7bd9@mail.gmail.com>
In-Reply-To: <dd18b0c30809091208t2821334dw60b592aac34e7bd9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> I've been noticing this message appear
> every "X" amount of boot's(maybe ten or so);
> 
> [19.656768] irq 23: nobody cared (try booting with the "irqpoll" option)
> [19.666039] Pid: 0, comm: swapper Tainted: P          2.6.27-rc5-00363-ga002d93
> [19.666764]  [<c0151774>] __report_bad_irq+0x2e/0x6f
> [19.666764]  [<c015199b>] note_interrupt+0x1e6/0x217
> [19.666764]  [<c0150d73>] ? handle_IRQ_event+0x2a/0x5a
> [19.666764]  [<c0151f4c>] handle_fastoei_irq+0x91/0xb6
> [19.666764]  [<c0104ff2>] do_IRQ+ox6c/0x86
> [19.666764]  [<c0103a6f>] common_interrupt+0x23/0x28
> [19.666764]  [<f886099a>] ? acpi_idle_enter_simple+0x19c/0x20e [processor]
> [19.666764]  [<c02ec323>] cpuidle_idle_call+ox5e/0x8b
> [19.666764]  [<c0101d42>] cpu_idle+0xda/0xfa
> [19.666764]  [<c038fde6>] rest_init+0x4e/0x50
> [19.666764]  =======================
> [19.666764] handlers:
> [19.666764] [<c02cca2b>] (usb_hcd_irq+0x0/0x79)
> [19.666764] [<c02cca2b>] (usb_hcd_irq+0x0/0x79)
> [19.666764] Disabling IRQ #23
> 
> normally upon booting leaving me unable
> to login.
> 

What's the proprietary module that's tainting it?  Ideally we'd like to see it 
reproduced on an untainted kernel, but depending on what it is, it may not matter.

When you say you're not able to log in, is that because the keyboard is 
unresponsive?  It appears to be affecting USB, so I'd be curious to know if you 
can ssh into the box, or log in with a PS/2 keyboard.  Of course, some PS/2 
ports are connected via USB under the hood, so the keyboard might not tell us much.

-- Chris
