Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbXHBItR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbXHBItR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbXHBItG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:49:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbXHBItE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:49:04 -0400
Date: Thu, 2 Aug 2007 01:48:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "debian developer" <debiandev@gmail.com>
Cc: "Andev Debi" <andev.debi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Problem - disabling IRQ #20 and others
Message-Id: <20070802014819.4760b06a.akpm@linux-foundation.org>
In-Reply-To: <f24d23310708010711w7cec4718tde8fd33b89fdfcf6@mail.gmail.com>
References: <ef8c225f0708010347l2a0a8e4cj4f47a243bba88989@mail.gmail.com>
	<f24d23310708010711w7cec4718tde8fd33b89fdfcf6@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 19:41:31 +0530 "debian developer" <debiandev@gmail.com> wrote:

> On 8/1/07, Andev Debi <andev.debi@gmail.com> wrote:
> > Hello,
> > Im getting the following error while booting the kernel 2.6.22.1-cfs
> >
> > Aug  1 09:14:17 localhost kernel: [   63.106550] irq 20: nobody cared (try
> > booting with the "irqpoll" option)
> > Aug  1 09:14:17 localhost kernel: [   63.106574]  [__report_bad_irq+36/128]
> > __report_bad_irq+0x24/0x80
> > Aug  1 09:14:17 localhost kernel: [   63.106596]  [note_interrupt+485/560]
> > note_interrupt+0x1e5/0x230
> > Aug  1 09:14:17 localhost kernel: [   63.106619]  [handle_IRQ_event+37/80]
> > handle_IRQ_event+0x25/0x50
> > Aug  1 09:14:17 localhost kernel: [   63.106634]
> > [handle_fasteoi_irq+141/160] handle_fasteoi_irq+0x8d/0xa0
> > Aug  1 09:14:17 localhost kernel: [   63.106643]  [do_IRQ+62/128]
> > do_IRQ+0x3e/0x80
> > Aug  1 09:14:17 localhost kernel: [   63.106665]  [common_interrupt+35/40]
> > common_interrupt+0x23/0x28
> > Aug  1 09:14:17 localhost kernel: [   63.106674]  [default_idle+0/64]
> > default_idle+0x0/0x40
> > Aug  1 09:14:17 localhost kernel: [   63.106696]  [default_idle+42/64]
> > default_idle+0x2a/0x40
> > Aug  1 09:14:17 localhost kernel: [   63.106704]  [cpu_idle+72/112]
> > cpu_idle+0x48/0x70
> > Aug  1 09:14:17 localhost kernel: [   63.106707]  [start_kernel+559/704]
> > start_kernel+0x22f/0x2c0
> > Aug  1 09:14:17 localhost kernel: [   63.106715]  [unknown_bootoption+0/592]
> > unknown_bootoption+0x0/0x250
> > Aug  1 09:14:17 localhost kernel: [   63.106735]  =======================
> > Aug  1 09:14:17 localhost kernel: [   63.106736] handlers:
> > Aug  1 09:14:17 localhost kernel: [   63.106738] [<dcc13080>]
> > (via_driver_irq_handler+0x0/0x1b0 [via])
> > Aug  1 09:14:17 localhost kernel: [   63.106747] Disabling IRQ #20
> >
> 

Please fix the wordwrapping before sending any more stuff - it's truly awful.

Could be a bug in the via driver, but it's more likely an
acpi/pci/platform/bios thing.

Did any previous kernels work OK?  If so, which?
