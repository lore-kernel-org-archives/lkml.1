Return-Path: <linux-kernel-owner+w=401wt.eu-S1754971AbYGJJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbYGJJ6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752430AbYGJJ6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 05:58:11 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:11626 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYGJJ6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 05:58:10 -0400
X-BigFish: VPS19(zz4015M62a3L1315m7cf0izz10d3izzz32i6bh87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3SBON-02-G7Z-01
Date: Thu, 10 Jul 2008 11:57:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: x86/pci: Broken build for X86_VISWS
Message-ID: <20080710095757.GB5607@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jul 2008 09:57:59.0239 (UTC) FILETIME=[6F0E6570:01C8E273]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

during testing of my pci changes I observed a build error if X86_VISWS
is set:

arch/x86/mach-visws/built-in.o: In function `machine_power_off':
(.text+0x48): undefined reference to `pci_bus0'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

The root cause is disabling PCI dependencies in change 1ac97018 that
disables compilation of x86/pci for VISWS though there are files in
needed to build. I am not sure if it is save to enable PCI for VISWS
to fix this.

Could you take a look at this?

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

