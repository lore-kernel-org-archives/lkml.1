Return-Path: <linux-kernel-owner+w=401wt.eu-S933995AbXK3Lu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbXK3Lu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759195AbXK3Luo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:50:44 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:6724 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759074AbXK3Lun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:50:43 -0500
Date: Fri, 30 Nov 2007 12:50:15 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Message-ID: <20071130115015.GC11682@osiris.boeblingen.de.ibm.com>
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com> <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:33:19PM +0530, Jaswinder Singh wrote:
> This patch fixes s390 dependency for x86
> 
> Signed-off-by: Jaswinder Singh <jaswinderlinux@gmail.com>

Deleting random parts of the kernel tree is actually not
supported.
 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 1330061..b699ed5 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -537,4 +537,6 @@ source "security/Kconfig"
> 
>  source "crypto/Kconfig"
> 
> +source "arch/s390/crypto/Kconfig"
> +

With this there's no dependency on CRYPTO_HW anymore.

> +#ifdef CONFIG_S390
>  #include "../arch/s390/appldata/appldata.h"
> +#endif

This include can go away.

Since this pops up again and again we'll come up with a patch to fix this.
