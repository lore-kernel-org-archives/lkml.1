Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab0BTAXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:23:09 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55442
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754217Ab0BTAXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:23:07 -0500
Date: Fri, 19 Feb 2010 16:23:21 -0800 (PST)
Message-Id: <20100219.162321.120454944.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100218.232928.193699814.davem@davemloft.net>
References: <20100218.232928.193699814.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Thu, 18 Feb 2010 23:29:28 -0800 (PST)

> The following changes since commit b0483e78e5c4c9871fc5541875b3bc006846d46b:
>   Linus Torvalds (1):
>         Merge git://git.kernel.org/.../gregkh/tty-2.6
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Linus, I've added a critical ITLB PTE execute bit handling fix
so if you've pulled already, please pull again.

Thanks!

The following changes since commit f8b55f251012e104093e105483c45c5d85ad3040:
  Christine Caulfield (1):
        Orphan DECnet

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (4):
      sparc64: Tighten checks in kstack_valid().
      Merge branch 'master' of /home/davem/src/GIT/linux-2.6/
      sparc64: Sync of_create_pci_dev() with drivers/pci/probe.c changes.
      sparc64: Fix sun4u execute bit check in TSB I-TLB load.

Kristoffer Glembo (1):
      sparc: Fix incorrect comparison in of_bus_ambapp_match()

 arch/sparc/kernel/kstack.h       |    4 ++++
 arch/sparc/kernel/of_device_32.c |    2 +-
 arch/sparc/kernel/pci.c          |    7 +++++++
 arch/sparc/kernel/tsb.S          |    6 ++++--
 4 files changed, 16 insertions(+), 3 deletions(-)
