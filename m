Return-Path: <linux-kernel-owner+w=401wt.eu-S1762759AbXGVVEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759AbXGVVEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 17:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbXGVVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 17:04:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49556 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbXGVVEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 17:04:32 -0400
Date: Sun, 22 Jul 2007 14:04:24 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linus 2.6.23-rc1
Message-ID: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, right on time, two weeks afetr 2.6.22, there's a 2.6.23-rc1 out there.

And it has a *ton* of changes as usual for the merge window, way too much 
for me to be able to post even just the shortlog or diffstat on the 
mailing list (but I had many people who wanted to full logs to stay 
around, so you'll continue to see those being uploaded to kernel.org).

Lots of architecture updates (for just about all of them - x86[-64], arm, 
alpha, mips, ia64, powerpc, s390, sh, sparc, um..), lots of driver updates 
(again, all over - usb, net, dvb, ide, sata, scsi, isdn, infiniband, 
firewire, i2c, you name it).

Filesystems, VM, networking, ACPI, it's all there. And virtualization all 
over the place (kvm, lguest, Xen).

Notable new things might be the merge of the cfs scheduler, and the UIO 
driver infrastructure might interest some people.

Oh, and I personally like how "sendfile" is now totally gone internally, 
and the kernel now ends up doing all that with splice insted. Good 
riddance, although we'll obvously end up supporting the old user level 
interfaces for a long time.

So give it all a good whacking, and report back about all the neat new 
features!

		Linus
