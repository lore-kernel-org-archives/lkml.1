Return-Path: <linux-kernel-owner+w=401wt.eu-S1030378AbXCMOSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030378AbXCMOSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 10:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030410AbXCMOSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 10:18:35 -0400
Received: from il.qumranet.com ([82.166.9.18]:41366 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030412AbXCMOSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 10:18:32 -0400
Message-ID: <45F6B2B5.4020200@qumranet.com>
Date: Tue, 13 Mar 2007 16:18:29 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: [GIT PULL] kvm updates for 2.6.21-rc3
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following kvm stability and correctness fixes since commit 
8b9909ded6922c33c221b105b26917780cfa497d:
  Linus Torvalds (1):
        Merge branch 'merge' of master.kernel.org:/.../paulus/powerpc

are found in the 'linus' branch of the git repository at:

  git://kvm.qumranet.com/home/avi/kvm.git

Avi Kivity (4):
      KVM: Unset kvm_arch_ops if arch module loading failed
      KVM: Fix guest sysenter on vmx
      KVM: MMU: Fix guest writes to nonpae pde
      KVM: MMU: Fix host memory corruption on i386 with >= 4GB ram

 drivers/kvm/kvm_main.c |    4 ++-
 drivers/kvm/mmu.c      |   52 
++++++++++++++++++++++++++++++++++-------------
 drivers/kvm/vmx.c      |    8 +++---
 3 files changed, 44 insertions(+), 20 deletions(-)

-- 
error compiling committee.c: too many arguments to function

