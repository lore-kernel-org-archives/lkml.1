Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbXK3Kho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbXK3Kho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbXK3Khb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:37:31 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:63591 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXK3Kha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:37:30 -0500
Date: Fri, 30 Nov 2007 11:37:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Message-ID: <20071130103728.GB11682@osiris.boeblingen.de.ibm.com>
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 01:44:56PM +0530, Jaswinder Singh wrote:
> 2.6.24-rc3 git kernel's x86 make depends on s390 arch:
> 
> 1.   HOSTLD  scripts/kconfig/conf
> scripts/kconfig/conf -s arch/x86/Kconfig
> drivers/crypto/Kconfig:51: can't open file "arch/s390/crypto/Kconfig"
> make[2]: *** [silentoldconfig] Error 1
> make[1]: *** [silentoldconfig] Error 2
> 
> 2.  CC      kernel/sysctl_check.o
> kernel/sysctl_check.c:3:44: error: ../arch/s390/appldata/appldata.h:
> No such file or directory
> make[1]: *** [kernel/sysctl_check.o] Error 1
> make: *** [kernel] Error 2

Could it be that you deleted half of the kernel tree? In specific
arch/[everything besides x86]*/ ?
