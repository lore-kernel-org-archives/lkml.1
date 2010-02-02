Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab0BBRBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:01:08 -0500
Received: from nerdhammel.gnuher.de ([88.198.0.170]:53144 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab0BBRBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:01:04 -0500
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Feb 2010 12:01:04 EST
Date: Tue, 2 Feb 2010 17:52:27 +0100
From: Sven Geggus <lists@fuchsschwanzdomain.de>
To: linux-kernel@vger.kernel.org
Subject: i915 drm/kms crash
Message-ID: <20100202165227.GA16964@geggus.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-MimeOLE: Produced By Exchange Microsoft V6.6.6
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I get the following crash on a Fujitu/Siemens ST6012 Tablet PC (kms enabled):

...
[    0.442322] [drm] Initialized drm 1.1.0 20060810
[    0.442478] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.442612] i915 0000:00:02.0: setting latency timer to 64
[    0.464043] i915 0000:00:02.0: irq 26 for MSI/MSI-X
[    0.464053] [drm] set up 31M of stolen space
[    0.566509] ------------[ cut here ]------------
[    0.566642] WARNING: at drivers/gpu/drm/drm_crtc_helper.c:1035 drm_helper_initial_config+0x41/0x5a()
[    0.566853] Hardware name: STYLISTIC ST6012
[    0.566978] No connectors reported connected with modes
[    0.567106] Modules linked in:
[    0.567273] Pid: 1, comm: swapper Not tainted 2.6.32.7 #3
[    0.567402] Call Trace:
[    0.567528]  [<ffffffff8129894b>] ? drm_helper_initial_config+0x41/0x5a
[    0.567661]  [<ffffffff8129894b>] ? drm_helper_initial_config+0x41/0x5a
[    0.567795]  [<ffffffff810458dd>] ? warn_slowpath_common+0x77/0xa3
[    0.567926]  [<ffffffff81045965>] ? warn_slowpath_fmt+0x51/0x59
[    0.568070]  [<ffffffff812c8848>] ? intel_crt_detect+0x26a/0x311
[    0.568202]  [<ffffffff81298818>] ? drm_helper_probe_single_connector_modes+0x1df/0x26b
[    0.568413]  [<ffffffff812988d9>] ? drm_helper_probe_connector_modes+0x35/0x66
[    0.568622]  [<ffffffff8129894b>] ? drm_helper_initial_config+0x41/0x5a
[    0.568756]  [<ffffffff812ad9c4>] ? i915_driver_load+0xf26/0xff2
[    0.568889]  [<ffffffff812a2d92>] ? drm_sysfs_device_add+0x7d/0x9e
[    0.569025]  [<ffffffff812a1072>] ? drm_get_dev+0x39e/0x488
[    0.569158]  [<ffffffff8122b652>] ? local_pci_probe+0x12/0x16
[    0.569289]  [<ffffffff8122c27a>] ? pci_device_probe+0xba/0xe3
[    0.569422]  [<ffffffff812dfa2f>] ? driver_probe_device+0x8d/0x128
[    0.569554]  [<ffffffff812dfb19>] ? __driver_attach+0x4f/0x6f
[    0.569685]  [<ffffffff812dfaca>] ? __driver_attach+0x0/0x6f
[    0.569816]  [<ffffffff812df2d4>] ? bus_for_each_dev+0x43/0x74
[    0.569947]  [<ffffffff812dec94>] ? bus_add_driver+0x116/0x25f
[    0.570079]  [<ffffffff812dfdb3>] ? driver_register+0xa7/0x111
[    0.570210]  [<ffffffff81738053>] ? i915_init+0x0/0x51
[    0.570341]  [<ffffffff8122c4b5>] ? __pci_register_driver+0x50/0xb7
[    0.570472]  [<ffffffff81738053>] ? i915_init+0x0/0x51
[    0.570603]  [<ffffffff81009051>] ? do_one_initcall+0x50/0x148
[    0.570735]  [<ffffffff81713629>] ? kernel_init+0x150/0x1a6
[    0.570866]  [<ffffffff81713140>] ? early_idt_handler+0x0/0x71
[    0.570998]  [<ffffffff8100cb5a>] ? child_rip+0xa/0x20
[    0.571128]  [<ffffffff81713140>] ? early_idt_handler+0x0/0x71
[    0.571259]  [<ffffffff817134d9>] ? kernel_init+0x0/0x1a6
[    0.571389]  [<ffffffff8100cb50>] ? child_rip+0x0/0x20
[    0.571522] ---[ end trace 6e64936bd3455b79 ]---

This is a vanilla Kernel (2.6.32.7)/ Debian testing system.

Linux (without framebuffer) and X.org used to work fine on Debian stable,
but I needed to upgrade for a newer Version of Mesa.

Regards

Sven

-- 
The main thing to note is that when you choose open source you don't
get a Windows operating system.
                                  (from http://www.dell.com/ubuntu)
/me is giggls@ircnet, http://sven.gegg.us/ on the Web
