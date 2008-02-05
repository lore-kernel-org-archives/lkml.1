Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbYBEMBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbYBEMBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 07:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750874AbYBEMBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 07:01:41 -0500
Received: from xspect.dk ([212.97.129.87]:48515 "EHLO xspect.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750753AbYBEMBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 07:01:40 -0500
X-Greylist: delayed 1505 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Feb 2008 07:01:40 EST
Date: Tue, 5 Feb 2008 12:36:33 +0100
From: "Klaus S. Madsen" <ksm@hjernemadsen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Felipe Balbi <felipebalbi@users.sourceforge.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: T61P sound issue
Message-ID: <20080205113633.GI27738@hjernemadsen.org>
References: <31e679430801270549u49e1c549qf602b36b07aabc2b@mail.gmail.com> <20080204194038.d8851b8d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080204194038.d8851b8d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 19:40:38 -0800, Andrew Morton wrote:
> On Sun, 27 Jan 2008 08:49:29 -0500 "Felipe Balbi" <felipebalbi@users.sourceforge.net> wrote:
> 
> If a bug report fell in a forest, would ...
> 
> > Hi all,
> > 
> > Could anyone make T61P's ICH8 sound controller to work properly?
> 
> ooh, a fellow t61p owner.  How's suspend and resume working?
I'm also a T61p owner, and for me suspend is working. I'm using Linux
2.6.24 (32 bit version) and the newest driver from NVidia (yes, I know I
should be using the opensource driver, but it didn't work when I got my
laptop).

I haven't got hibernation working yet, but I haven't yet tried without
the NVidia module loaded (and as suspend works, hibernation isn't that
important for me).

> > Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 03)
> > 
> > Running linux-2.6.24 stable. If there's a know bug, I could try to dig
> > more on it and get more info.
> 
> It works for me.  http://userweb.kernel.org/~akpm/config-t61p.txt
Sound also works for me. Config at http://hogthrob.42.dk/config-t61p.txt

> > Call Trace:
> >  <IRQ>  [<ffffffff80263b5f>] __report_bad_irq+0x30/0x72
> >  [<ffffffff80263dcb>] note_interrupt+0x22a/0x26b
> >  [<ffffffff8026463a>] handle_fasteoi_irq+0xa9/0xd0
> >  [<ffffffff8020e6cf>] do_IRQ+0x6c/0xd5
> >  [<ffffffff8020c411>] ret_from_intr+0x0/0xa
> >  [<ffffffff8021c1a4>] lapic_next_event+0x0/0xa
> >  [<ffffffff8023a692>] __do_softirq+0x5a/0xce
> >  [<ffffffff8024f060>] tick_program_event+0x31/0x4d
> >  [<ffffffff8020d08c>] call_softirq+0x1c/0x28
> >  [<ffffffff8020e4e0>] do_softirq+0x2c/0x7d
> >  [<ffffffff8023a5f3>] irq_exit+0x3f/0x84
> >  [<ffffffff8021c55c>] smp_apic_timer_interrupt+0x3f/0x53
> >  [<ffffffff8020cb36>] apic_timer_interrupt+0x66/0x70
> >  <EOI> 
> > handlers:
> > [<ffffffff803fa647>] (usb_hcd_irq+0x0/0x52)
> > Disabling IRQ #19
> > 
> 
> (everyone gets this btw - some weird bluetooth-vs-usb thing which we don't
> know how to fix).
This is actually fixed by upgrading to the newest version of the BIOS.
I'm currently running version 7LETA7WW (2.07), and haven't seen the
problem since I upgraded.

-- 
Med venlig hilsen
	Klaus S. Madsen
