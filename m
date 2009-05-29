Return-Path: <linux-kernel-owner+w=401wt.eu-S1755606AbZE2HSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606AbZE2HSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 03:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbZE2HSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 03:18:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:43336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbZE2HSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 03:18:37 -0400
Subject: [PATCH] KVM: add localversion to avoid confusion and conflicts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, KVM list <kvm@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 29 May 2009 12:48:14 +0530
Message-Id: <1243581494.3212.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Adding localversion avoids confusion in kernel images :

like Linux version 2.6.30-rc7 does not tell whether it is linus or kvm kernel.

By adding localversion it tells :

Linux version 2.6.30-rc7-kvm , any doubt ;-)

Secondly, by installing modules it overwrites on linus modules.

By adding localversion :

[root@hpdv5 kvm]# make modules_install
  INSTALL arch/x86/kernel/cpu/cpu_debug.ko
  INSTALL arch/x86/kernel/test_nx.ko
  INSTALL arch/x86/kvm/kvm-amd.ko
  INSTALL arch/x86/kvm/kvm-intel.ko
  INSTALL arch/x86/kvm/kvm.ko
  INSTALL arch/x86/oprofile/oprofile.ko
  INSTALL drivers/scsi/scsi_wait_scan.ko
  INSTALL drivers/virtio/virtio.ko
  INSTALL drivers/virtio/virtio_balloon.ko
  INSTALL drivers/virtio/virtio_pci.ko
  INSTALL drivers/virtio/virtio_ring.ko
  DEPMOD  2.6.30-rc7-kvm

I am inspired by Ingo's -tip, I am sure Ingo will tell more advantages,
if these are not enough :-)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 localversion-kvm |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 100644 localversion-kvm

diff --git a/localversion-kvm b/localversion-kvm
new file mode 100644
index 0000000..d969ff0
--- /dev/null
+++ b/localversion-kvm
@@ -0,0 +1 @@
+-kvm
-- 
1.6.0.6



