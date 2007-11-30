Return-Path: <linux-kernel-owner+w=401wt.eu-S934465AbXK3LQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934465AbXK3LQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932705AbXK3LQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:16:31 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:39579 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934424AbXK3LQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:16:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B8skq4/fJfMJ+mBJh7E+JzpOGodFOWKmiDBVzxQOVqs0rjksPIyxwtVgelPKRPITr2PqWfG851QjH6pAsXT2aT3S94Wtou1H3f0zyXNec9nLOsjPCjBTD6URtcRXxapdhqGvESV6MreOCrqZND8vnyYntKRlyzzF/KJZei+vd6Y=
Message-ID: <3f9a31f40711300316n582e38eel5799df8167ac3577@mail.gmail.com>
Date: Fri, 30 Nov 2007 16:46:23 +0530
From: "Jaswinder Singh" <jaswinderlinux@gmail.com>
To: "Heiko Carstens" <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071130103728.GB11682@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com>
	 <20071130103728.GB11682@osiris.boeblingen.de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, what is the use of keeping other arch, if I am not going to build those.

Thank you,

Jaswinder Singh.

On 11/30/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On Fri, Nov 30, 2007 at 01:44:56PM +0530, Jaswinder Singh wrote:
> > 2.6.24-rc3 git kernel's x86 make depends on s390 arch:
> >
> > 1.   HOSTLD  scripts/kconfig/conf
> > scripts/kconfig/conf -s arch/x86/Kconfig
> > drivers/crypto/Kconfig:51: can't open file "arch/s390/crypto/Kconfig"
> > make[2]: *** [silentoldconfig] Error 1
> > make[1]: *** [silentoldconfig] Error 2
> >
> > 2.  CC      kernel/sysctl_check.o
> > kernel/sysctl_check.c:3:44: error: ../arch/s390/appldata/appldata.h:
> > No such file or directory
> > make[1]: *** [kernel/sysctl_check.o] Error 1
> > make: *** [kernel] Error 2
>
> Could it be that you deleted half of the kernel tree? In specific
> arch/[everything besides x86]*/ ?
>
