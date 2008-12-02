Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYLBSXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYLBSXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 13:23:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYLBSXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 13:23:12 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50611 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbYLBSXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 13:23:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=syBx6/FGgMNCqnOWn8xM1lw+Yqzb66ddg2RAgVGm29qUQpUgQwPMxknWqc9QiKDeas
         rBwJs6Ouh4iTL2uTFMOXCOoEIEX/VOvSaV2uHewhuFbiiLGdXdpVQ37yk6WrrniOjy2S
         qlgANa273OhgHiPpkyEpt9wbptya5p+olV1cA=
Subject: Re: [i915 drm] irq 16: nobody cared with latest git kernels
From: Ben Gamari <bgamari@gmail.com>
To: fredi ml <mailinglists.fredi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Anholt <eric@anholt.net>,
       dri-devel@lists.sourceforge.net
In-Reply-To: <f958598b0812020521g64320db0q1cbd4e3c189d6af7@mail.gmail.com>
References: <f958598b0812020521g64320db0q1cbd4e3c189d6af7@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 02 Dec 2008 13:23:01 -0500
Message-Id: <1228242181.3578.6.camel@mercury.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bug was first reported a few weeks ago and it seems still hasn't
been resolved for some. The bug report can be found here,
https://bugs.freedesktop.org/show_bug.cgi?id=18609 .

- Ben


On Tue, 2008-12-02 at 14:21 +0100, fredi ml wrote:
> Hi all,
> lately starting from kernel 2.6.28-rc6-00142-g9bd062d I'm getting this
> traces: 
> 
> Dec  1 12:09:34 kotys irq 16: nobody cared (try booting with the
> "irqpoll" option)
> Dec  1 12:09:34 kotys Pid: 3617, comm: X Not tainted
> 2.6.28-rc6-00142-g9bd062d #17
> Dec  1 12:09:34 kotys Call Trace:
> Dec  1 12:09:34 kotys <IRQ>  [<ffffffff80262a11>] __report_bad_irq
> +0x3d/0x8c
> Dec  1 12:09:34 kotys [<ffffffff80262b73>] note_interrupt+0x113/0x178
> Dec  1 12:09:34 kotys [<ffffffff80263271>] handle_fasteoi_irq
> +0xa6/0xca
> Dec  1 12:09:34 kotys [<ffffffff8020d8ab>] do_IRQ+0x7b/0xec
> Dec  1 12:09:34 kotys [<ffffffff8020b9f6>] ret_from_intr+0x0/0xa
> Dec  1 12:09:34 kotys <EOI> <3>handlers:
> Dec  1 12:09:34 kotys [<ffffffffa036f497>] (i915_driver_irq_handler
> +0x0/0x1f5 [i915])
> Dec  1 12:09:34 kotys Disabling IRQ #16
> 
> -----------
> Dec  1 19:14:11 kotys irq 16: nobody cared (try booting with the
> "irqpoll" option)
> Dec  1 19:14:11 kotys Pid: 4042, comm: firefox Not tainted
> 2.6.28-rc6-00184-gd9d060a #18
> Dec  1 19:14:11 kotys Call Trace:
> Dec  1 19:14:11 kotys <IRQ>  [<ffffffff80262a11>] __report_bad_irq
> +0x3d/0x8c
> Dec  1 19:14:11 kotys [<ffffffff80262b73>] note_interrupt+0x113/0x178
> Dec  1 19:14:11 kotys [<ffffffff80263271>] handle_fasteoi_irq
> +0xa6/0xca
> Dec  1 19:14:11 kotys [<ffffffff8020d8ab>] do_IRQ+0x7b/0xec
> Dec  1 19:14:11 kotys [<ffffffff8020b9f6>] ret_from_intr+0x0/0xa
> Dec  1 19:14:11 kotys <EOI> <3>handlers:
> Dec  1 19:14:11 kotys [<ffffffffa036c497>] (i915_driver_irq_handler
> +0x0/0x1f5 [i915])
> Dec  1 19:14:11 kotys Disabling IRQ #16
> 
> ------------
> Dec  2 13:31:23 kotys Pid: 6512, comm: ebuild Not tainted 2.6.28-rc7
> #19
> Dec  2 13:31:23 kotys Call Trace:
> Dec  2 13:31:23 kotys <IRQ>  [<ffffffff80262a0d>] __report_bad_irq
> +0x3d/0x8c
> Dec  2 13:31:23 kotys [<ffffffff80262b6f>] note_interrupt+0x113/0x178
> Dec  2 13:31:23 kotys [<ffffffff8026326d>] handle_fasteoi_irq
> +0xa6/0xca
> Dec  2 13:31:23 kotys [<ffffffff8020d8ab>] do_IRQ+0x7b/0xec
> Dec  2 13:31:23 kotys [<ffffffff8020b9f6>] ret_from_intr+0x0/0xa
> Dec  2 13:31:23 kotys <EOI> <3>handlers:
> Dec  2 13:31:23 kotys [<ffffffffa036b497>] (i915_driver_irq_handler
> +0x0/0x1f5 [i915])
> Dec  2 13:31:23 kotys Disabling IRQ #16
> 
> 
> Actually now that i notice all the log seems the same except the
> kernel version that's from git. After this traces interrupt 16 is not
> incrteasing in /proc/interrupts anymore (as suggested by the last log
> line) and Xorg is all slugish, barely usable. Noticing that there were
> modifications on the i915 driver i waited till now to report this but
> none of the last patches got rid of this issue so here is the log.
> Right now i booted adding irqpoll on the command line and i see in
> dmesg this one:
> 
> Kernel command line: root=/dev/sda2 rootflags=data=writeback irqpoll
> Misrouted IRQ fixup and polling support enabled
> This may significantly impact system performance
> 
> Though everything seems normal for now. The trace happens usually when
> the system is under load but it's not that predictable so for now i
> cant tell if using irqpoll is avoiding hitting this issue. I'll let
> you know if it happens again.
> Just ask for info or whatever patches to test ecc. is needed, i'll be
> glad to help.
> And of course thank you guys for your work.
> 
> Frederik
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> -- _______________________________________________ Dri-devel mailing list Dri-devel@lists.sourceforge.net https://lists.sourceforge.net/lists/listinfo/dri-devel

