Return-Path: <linux-kernel-owner+w=401wt.eu-S1758966AbZKEVUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966AbZKEVUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 16:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758693AbZKEVUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 16:20:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758371AbZKEVUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 16:20:17 -0500
Date: Thu, 5 Nov 2009 19:19:56 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@redhat.com>
Subject: [GIT PULL] KVM updates for 2.6.32-rc6
Message-ID: <20091105211956.GA2622@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull from

git://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-updates/2.6.32

For two KVM fixes: >4GB TSS access in task switch emulation and MCE
ioctl overflow.

Gleb Natapov (1):
      KVM: get_tss_base_addr() should return a gpa_t

Jan Kiszka (1):
      KVM: x86: Catch potential overrun in MCE setup

 arch/x86/kvm/x86.c   |    2 +-
 b/arch/x86/kvm/x86.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
