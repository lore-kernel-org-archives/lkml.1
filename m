Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYBEDkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYBEDkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 22:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYBEDkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 22:40:31 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38555 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917AbYBEDka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 22:40:30 -0500
Date: Mon, 4 Feb 2008 19:40:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
Message-Id: <20080204194038.d8851b8d.akpm@linux-foundation.org>
In-Reply-To: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 08:49:29 -0500 "Felipe Balbi" <felipebalbi@users.sourceforge.net> wrote:

If a bug report fell in a forest, would ...

> Hi all,
> 
> Could anyone make T61P's ICH8 sound controller to work properly?

ooh, a fellow t61p owner.  How's suspend and resume working?

> Here's lspci |grep -i audio:
> Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
> 
> Running linux-2.6.24 stable. If there's a know bug, I could try to dig
> more on it and get more info.

It works for me.  http://userweb.kernel.org/~akpm/config-t61p.txt

> Attached is my .config and dmesg output

If it's still busted please cc the "SOUND" developers (from ./MAINTAINERS)
on the reply, thanks.


> Call Trace:
>  <IRQ>  [<ffffffff80263b5f>] __report_bad_irq+0x30/0x72
>  [<ffffffff80263dcb>] note_interrupt+0x22a/0x26b
>  [<ffffffff8026463a>] handle_fasteoi_irq+0xa9/0xd0
>  [<ffffffff8020e6cf>] do_IRQ+0x6c/0xd5
>  [<ffffffff8020c411>] ret_from_intr+0x0/0xa
>  [<ffffffff8021c1a4>] lapic_next_event+0x0/0xa
>  [<ffffffff8023a692>] __do_softirq+0x5a/0xce
>  [<ffffffff8024f060>] tick_program_event+0x31/0x4d
>  [<ffffffff8020d08c>] call_softirq+0x1c/0x28
>  [<ffffffff8020e4e0>] do_softirq+0x2c/0x7d
>  [<ffffffff8023a5f3>] irq_exit+0x3f/0x84
>  [<ffffffff8021c55c>] smp_apic_timer_interrupt+0x3f/0x53
>  [<ffffffff8020cb36>] apic_timer_interrupt+0x66/0x70
>  <EOI> 
> handlers:
> [<ffffffff803fa647>] (usb_hcd_irq+0x0/0x52)
> Disabling IRQ #19
> 

(everyone gets this btw - some weird bluetooth-vs-usb thing which we don't
know how to fix).

