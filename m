Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYBXEjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYBXEjm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:39:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758724AbYBXEjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:39:23 -0500
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:37636 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758674AbYBXEjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:39:22 -0500
Date: Sun, 24 Feb 2008 15:36:31 +1100
To: Jeff Garzik <jeff@garzik.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Lguest] lguest breaks i386 allmodconfig
Message-ID: <20080224043631.GS6887@bakeyournoodle.com>
References: <47C0F363.6050509@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47C0F363.6050509@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2008 at 11:32:35PM -0500, Jeff Garzik wrote:
> The following
> 
> 	make ARCH=i386 allmodconfig && \
> 	make ARCH=i386 -sj5
> 
> on x86-64 produces the following build breakage at the post-build stage:
> 
> [...]
> Root device is (9, 0)
> Setup is 12504 bytes (padded to 12800 bytes).
> System is 1883 kB
> Kernel: arch/x86/boot/bzImage is ready  (#2)
> ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
> ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!
> [...]

I suspect that the various patches in this thread
(http://marc.info/?t=120339302000002) will fix this problem.
It's a matter of which on Linus takes, and when.

Yours Tony

  linux.conf.au    http://www.marchsouth.org/
  Jan 19 - 24 2009 The Australian Linux Technical Conference!

