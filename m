Return-Path: <linux-kernel-owner+w=401wt.eu-S1756630AbXFSViT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630AbXFSViT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbXFSViG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:38:06 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4222 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbXFSViF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:38:05 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
Date: Tue, 19 Jun 2007 23:37:49 +0200
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706192337.49505.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	MAINTAINERS says riscom8 is orphaned so not sure
if anybody cares. Spotted this when playing with modprobe
walking /lib/modules/`uname -r`/kernel in a loop ;)

BUG: sleeping function called from invalid context at kernel/mutex.c:86
in_atomic():0, irqs_disabled():1
 [<c0104542>] show_trace_log_lvl+0x1a/0x30
 [<c01050d0>] show_trace+0x12/0x14
 [<c010515b>] dump_stack+0x15/0x17
 [<c0112bd4>] __might_sleep+0xa8/0xae
 [<c04148ff>] mutex_lock+0x15/0x1f
 [<c015f82f>] __unregister_chrdev_region+0x1a/0x85
 [<c015f8f7>] unregister_chrdev_region+0x2f/0x3e
 [<c029c710>] tty_unregister_driver+0x30/0x100
 [<df082011>] rc_release_drivers+0x11/0x20 [riscom8]
 [<df08960c>] riscom8_init_module+0x539/0x57a [riscom8]
 [<c01345c2>] sys_init_module+0x11b/0x167e
 [<c0103ee6>] sysenter_past_esp+0x5f/0x85
 =======================

Regards,

	Mariusz
