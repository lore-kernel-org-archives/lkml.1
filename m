Return-Path: <linux-kernel-owner+w=401wt.eu-S1752606AbYIIX5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbYIIX5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbYIIX47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:56:59 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:18606 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYIIX46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=dWcdb+Gh9V6CGJDezSAQ1B8pob7xir37a7Y0sEFscTsy9MEI/bGB9fDY8MQ3qEKn+O
         UJERNLI01/8mum3QacopzUbiymbmr6+F82F1m843FhuQN2EVMRTCN43Gc5EqWX2Jd6Tf
         nsiFthqjA9FhSnoW3lKzU6EAK3BLO4whQWe1g=
References: <dd18b0c30809091208t2821334dw60b592aac34e7bd9@mail.gmail.com> <48C706B3.4070409@redhat.com>
Message-Id: <92D1B39E-9EF1-4D8F-B2C0-B1D2716AC4A9@gmail.com>
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Chris Snook <csnook@redhat.com>
In-Reply-To: <48C706B3.4070409@redhat.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (5C1)
Mime-Version: 1.0 (iPhone Mail 5C1)
Subject: Re: [19.666764] Disabling IRQ #23
Date: Tue, 9 Sep 2008 16:56:52 -0700
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only proprietary modules
Atheros and Fglrx. Which confuses me, due to the message giving
Info on USB. As for the login,
On a MacBook I need uhci
To use the keyboard. When this
Goes off I can type, but results
In the letter duplicating itself I.g.
Typing the letter * results in **
As for using ssh, no.
I guess as a workaround I can try and change my login name and password
With double letters so I can grab a copy of dmesg

justin P. Mattock



On Sep 9, 2008, at 4:28 PM, Chris Snook <csnook@redhat.com> wrote:

> Justin Mattock wrote:
>> I've been noticing this message appear
>> every "X" amount of boot's(maybe ten or so);
>> [19.656768] irq 23: nobody cared (try booting with the "irqpoll"  
>> option)
>> [19.666039] Pid: 0, comm: swapper Tainted: P          2.6.27- 
>> rc5-00363-ga002d93
>> [19.666764]  [<c0151774>] __report_bad_irq+0x2e/0x6f
>> [19.666764]  [<c015199b>] note_interrupt+0x1e6/0x217
>> [19.666764]  [<c0150d73>] ? handle_IRQ_event+0x2a/0x5a
>> [19.666764]  [<c0151f4c>] handle_fastoei_irq+0x91/0xb6
>> [19.666764]  [<c0104ff2>] do_IRQ+ox6c/0x86
>> [19.666764]  [<c0103a6f>] common_interrupt+0x23/0x28
>> [19.666764]  [<f886099a>] ? acpi_idle_enter_simple+0x19c/0x20e  
>> [processor]
>> [19.666764]  [<c02ec323>] cpuidle_idle_call+ox5e/0x8b
>> [19.666764]  [<c0101d42>] cpu_idle+0xda/0xfa
>> [19.666764]  [<c038fde6>] rest_init+0x4e/0x50
>> [19.666764]  =======================
>> [19.666764] handlers:
>> [19.666764] [<c02cca2b>] (usb_hcd_irq+0x0/0x79)
>> [19.666764] [<c02cca2b>] (usb_hcd_irq+0x0/0x79)
>> [19.666764] Disabling IRQ #23
>> normally upon booting leaving me unable
>> to login.
>
> What's the proprietary module that's tainting it?  Ideally we'd like  
> to see it reproduced on an untainted kernel, but depending on what  
> it is, it may not matter.
>
> When you say you're not able to log in, is that because the keyboard  
> is unresponsive?  It appears to be affecting USB, so I'd be curious  
> to know if you can ssh into the box, or log in with a PS/2  
> keyboard.  Of course, some PS/2 ports are connected via USB under  
> the hood, so the keyboard might not tell us much.
>
> -- Chris
