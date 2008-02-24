Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbYBXEcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbYBXEcw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 23:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbYBXEcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 23:32:46 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:33453 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbYBXEcp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 23:32:45 -0500
Message-ID: <47C0F363.6050509@garzik.org>
Date: Sat, 23 Feb 2008 23:32:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, lguest@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: lguest breaks i386 allmodconfig
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following

	make ARCH=i386 allmodconfig && \
	make ARCH=i386 -sj5

on x86-64 produces the following build breakage at the post-build stage:

[...]
Root device is (9, 0)
Setup is 12504 bytes (padded to 12800 bytes).
System is 1883 kB
Kernel: arch/x86/boot/bzImage is ready  (#2)
ERROR: "LGUEST_PAGES_guest_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_gdt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_cr3" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_regs" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_idt_desc" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_guest_gdt" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_host_sp" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_regs_trapnum" [drivers/lguest/lg.ko] undefined!
ERROR: "LGUEST_PAGES_guest_idt_desc" [drivers/lguest/lg.ko] undefined!
[...]

