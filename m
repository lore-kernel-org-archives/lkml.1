Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbXGCJBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbXGCJBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 05:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771AbXGCJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 05:01:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:38840 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753841AbXGCJBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 05:01:40 -0400
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <4BEFAFC6-3346-4F29-B1C5-377952E3FBBF@kernel.crashing.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@samba.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: How to handle patches that cross maintainers?
Date: Tue, 3 Jul 2007 04:01:20 -0500
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

I was hoping to get your input on how to handle patches that cross  
maintainers.  I've got a patch that is pretty PPC specific, but  
happens to touch some drivers as well.

Here's the diffstat to get a rough idea:

arch/powerpc/kernel/io.c                |   12 ++++++------
arch/powerpc/mm/hash_native_64.c        |    2 +-
arch/powerpc/mm/stab.c                  |    4 ++--
drivers/ide/pci/scc_pata.c              |    4 ++--
drivers/media/dvb/bt8xx/bt878.h         |    5 ++---
drivers/serial/cpm_uart/cpm_uart_core.c |    2 +-
include/asm-powerpc/system.h            |    2 +-
7 files changed, 15 insertions(+), 16 deletions(-)

Now, I've had this issue before w/o any good sense on how to handle it.

Suggestions?

- k
