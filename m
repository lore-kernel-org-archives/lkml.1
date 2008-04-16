Return-Path: <linux-kernel-owner+w=401wt.eu-S1765046AbYDPOrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765046AbYDPOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 10:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYDPOrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 10:47:42 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:39231
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605AbYDPOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 10:47:41 -0400
Message-ID: <4806118C.7090706@qumranet.com>
Date: Wed, 16 Apr 2008 17:47:40 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-66 release
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's new kvm architecture is ia64, aka Itanium 2.  Like s390, it is 
only provided in the git tree, not in the tarball.  Windows and Linux 
guests are supported.

On good old x86, we have a the new kvmtrace performance monitoring 
framework together with a sizable number of bug fixes.

Changes from kvm-65:
- adjust external module for 2.6.25 module locations (Anthony Liguori)
- fix userspace compilation failure without kernel pit (Joerg Roedel)
- kvmtrace performance monitoring mechanism (Eric Liu)
- stop all vcpus before saving their state (Marcelo Tosatti)
   - fixes smp live migration
- save/restore kernel apicbase (Marcelo Tosatti)
- block SIG_IPI signals (Marcelo Tosatti)
- smsw mem16, lmsw mem16 emulation and unit tests
- fix compile warnings (Jerone Young)
- fix reset with iothread
- ia64 architecture support (Xiantao Zhang, Anthony Xu)
- don't assume guest pages are backed by a 'struct page' (Anthony Liguori)
   - needed for pci device assignment
- register kvm's ioctl range
- fix hardware task switching buglet (Izik Eidus)
- fix mce handling on AMD (Joerg Roedel)
- do hardware task switching in hardware when NPT is enabled (Joerg Roedel)
- fix timer race waking up a halted vcpu with smp (Marcelo Tosatti)
- fix irq race leading to irqs delivery delays (Marcelo Tosatti)
- fix triple fault handling on AMD
- fix lea instruction emulation


Notes:
      If you use the modules bundled with kvm-66, you can use any version
of Linux from 2.6.17 upwards.
      If you use the modules bundled with Linux 2.6.20, you need to use
kvm-12.
      If you use the modules bundled with Linux 2.6.21, you need to use
kvm-17.
      Modules from Linux 2.6.22 and up will work with any kvm version from
kvm-22.  Some features may only be available in newer releases.
      For best performance, use Linux 2.6.23-rc2 or later as the host.

http://kvm.qumranet.com

