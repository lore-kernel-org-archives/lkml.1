Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYIIXNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYIIXNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYIIXNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:13:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45803
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754035AbYIIXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:13:11 -0400
Date: Tue, 09 Sep 2008 16:13:05 -0700 (PDT)
Message-Id: <20080909.161305.140912606.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had always gotten strange wedges when hot plugging cpus on
Niagara boxes via the hypervisor, and I think the following
bug spotted by Paul McKenney finally nails it.

Please pull, thanks a lot.

The following changes since commit 4d084617fb0d025c42c242362d1f27d337e2d407:
  Paul E. McKenney (1):
        sparc64: Prevent sparc64 from invoking irq handlers on offline CPUs

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Disable timer interrupts in fixup_irqs().

 arch/sparc64/kernel/irq.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
