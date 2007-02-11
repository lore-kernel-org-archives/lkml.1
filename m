Return-Path: <linux-kernel-owner+w=401wt.eu-S1751644AbXBKPJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644AbXBKPJm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 10:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbXBKPJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 10:09:42 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:44541 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbXBKPJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 10:09:41 -0500
Message-ID: <45CF318D.4010401@garzik.org>
Date: Sun, 11 Feb 2007 10:09:01 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070130)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Tejun Heo <htejun@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [patch] linux/io.h: forward declare struct pci_dev
References: <20070210114550.GC12642@osiris.boeblingen.de.ibm.com> <20070211034902.GA9077@infradead.org> <45CEB720.1020406@gmail.com> <20070211063431.GS10050@ftp.linux.org.uk>
In-Reply-To: <20070211063431.GS10050@ftp.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  arch/arm/Kconfig           |    5 +
>  arch/cris/Kconfig          |    3 +
>  arch/h8300/Kconfig         |    3 +
>  arch/h8300/kernel/Makefile |    4 +-
>  arch/m32r/Kconfig          |    3 +
>  arch/m68k/Kconfig          |    3 +
>  arch/m68k/kernel/Makefile  |    4 +-
>  arch/m68knommu/Kconfig     |    3 +
>  arch/s390/Kconfig          |    3 +
>  arch/sparc/kernel/Makefile |    4 +-
>  arch/um/Kconfig            |    3 +
>  arch/xtensa/Kconfig        |    3 +
>  include/linux/io.h         |    6 -
>  include/linux/pci.h        |    5 +
>  kernel/irq/Makefile        |    2 +-
>  kernel/irq/devres.c        |   88 +++++++++++++
>  kernel/irq/manage.c        |   86 -------------
>  lib/Kconfig                |    9 +-
>  lib/Makefile               |    5 +-
>  lib/devres.c               |  300 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/iomap.c                |  296 -------------------------------------------
>  21 files changed, 442 insertions(+), 396 deletions(-)
>  create mode 100644 kernel/irq/devres.c
>  create mode 100644 lib/devres.c


Seems sane to me.

	Jeff


