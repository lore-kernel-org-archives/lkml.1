Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbYD1I4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbYD1I4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYD1I4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:56:09 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:44044
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbYD1I4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:56:07 -0400
Message-ID: <48159126.6010509@qumranet.com>
Date: Mon, 28 Apr 2008 11:56:06 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: kvm-devel <kvm-devel@lists.sourceforge.net>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE] kvm-67 release
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This release adds support for the ppc 44x embedded processors. Like s390 
and ia64, it is only provided in the git tree, not in the tarball. 
Linux guests are supported.

Changes from kvm-66:
- s390/ia64: compile fix (Christian Borntraeger)
- s390: change virtio interrupt to follow arch specification
   (Christian Borntraeger)
- close vcpu refcounting race (Al Viro)
- code cleanups (Hollis Blanchard, Christian Borntraeger)
- ppc 44x support (Hollis Blanchard, Jerone Young)
- reduce cr8 intercepts on AMD (Joerg Roedel)
   - speeds up Vista x64
- fix locking in paravirt mmu support (Marcelo Tosatti)
- fix ppc build on non-44x (Stephen Rothwell)
- fix PIT time-drift compensation with multiple guests (Marcelo Tosatti)
- merge qemu-svn
- spin up vcpu threads before setting lapic contents
- pass disk geometery to extboot loader (Ryan Harper)
- separate header copying from source copying in 'make sync'
- implement 'hypervisor present' cpuid bit
- fix address truncation on ia64 (Jes Sorensen)
- handle nic/storage hotplug failure gracefully (Chris Wright)
- more kvm_stat display options
- fix qemu system_powerdown with Linux guests


Notes:
      If you use the modules bundled with kvm-67, you can use any version
of Linux from 2.6.17 upwards.
      If you use the modules bundled with Linux 2.6.20, you need to use
kvm-12.
      If you use the modules bundled with Linux 2.6.21, you need to use
kvm-17.
      Modules from Linux 2.6.22 and up will work with any kvm version from
kvm-22.  Some features may only be available in newer releases.
      For best performance, use Linux 2.6.23-rc2 or later as the host.

http://kvm.qumranet.com

