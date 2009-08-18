Return-Path: <linux-kernel-owner+w=401wt.eu-S932712AbZHRBbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932712AbZHRBbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 21:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932653AbZHRBbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 21:31:13 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44247
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932668AbZHRBbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 21:31:11 -0400
Date: Mon, 17 Aug 2009 18:31:22 -0700 (PDT)
Message-Id: <20090817.183122.242955779.davem@davemloft.net>
To: hch@lst.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc32: convert to asm-generic/hardirq.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090816.182855.76805469.davem@davemloft.net>
References: <20090804145615.GM20487@lst.de>
	<20090816.182855.76805469.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 16 Aug 2009 18:28:55 -0700 (PDT)

> From: Christoph Hellwig <hch@lst.de>
> Date: Tue, 4 Aug 2009 16:56:15 +0200
> 
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Applied, thanks.
> 
> Please post sparc patches at least CC:'d to sparclinux@vger.kernel.org
> in the future.

I have to revert this, it breaks the build.

  CC      init/main.o
In file included from include/asm-generic/hardirq.h:6,
                 from /home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/hardirq_32.h:11,
                 from /home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/hardirq.h:6,
                 from include/linux/hardirq.h:10,
                 from include/linux/interrupt.h:12,
                 from /home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/irq_32.h:9,
                 from /home/davem/src/GIT/sparc-next-2.6/arch/sparc/include/asm/irq.h:6,
                 from include/linux/irqnr.h:10,
                 from include/linux/random.h:12,
                 from include/linux/stackprotector.h:6,
                 from init/main.c:17:
include/linux/irq.h:208: error: 'NR_IRQS' undeclared here (not in a function)
make[1]: *** [init/main.o] Error 1
make: *** [init] Error 2
