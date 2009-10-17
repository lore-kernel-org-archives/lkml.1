Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbZJQQAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbZJQQAZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 12:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZJQQAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 12:00:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51311 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZJQQAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 12:00:24 -0400
Date: Sat, 17 Oct 2009 12:59:33 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.32-rc5
Message-ID: <20091017155933.GA5700@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from 

git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.32

For three KVM fixes: a bug in initialization of debugfs files, 
32-bit compile warning fix on KSM glue, and a NULL pointer
dereference in timer emulation.


Darrick J. Wong (1):
      KVM: Prevent kvm_init from corrupting debugfs structures

Frederik Deweerdt (1):
      KVM: MMU: fix pointer cast

Marcelo Tosatti (1):
      KVM: use proper hrtimer function to retrieve expiration time


 arch/x86/kvm/i8254.c |    2 +-
 arch/x86/kvm/lapic.c |    2 +-
 arch/x86/kvm/mmu.c   |   16 ++++++++++------
 virt/kvm/kvm_main.c  |    7 +++----
 4 files changed, 15 insertions(+), 12 deletions(-)


