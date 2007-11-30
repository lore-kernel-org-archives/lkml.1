Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbXK3Mul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbXK3Mul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 07:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbXK3Mu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 07:50:28 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:31186 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbXK3Mu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 07:50:28 -0500
Date: Fri, 30 Nov 2007 13:49:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jaswinder Singh <jaswinderlinux@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] Re: [BUG] 2.6.24-rc3 x86 make depends on s390 arch
Message-ID: <20071130124958.GD11682@osiris.boeblingen.de.ibm.com>
References: <3f9a31f40711300014y576e83dldfafa340eec257f0@mail.gmail.com> <3f9a31f40711300303l3260c3e7s4c35884f5e1fa6e1@mail.gmail.com> <20071130115015.GC11682@osiris.boeblingen.de.ibm.com> <3f9a31f40711300408s4341a338n33e5b6dbaee05813@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40711300408s4341a338n33e5b6dbaee05813@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> > > index 1330061..b699ed5 100644
> > > --- a/arch/s390/Kconfig
> > > +++ b/arch/s390/Kconfig
> > > @@ -537,4 +537,6 @@ source "security/Kconfig"
> > >
> > >  source "crypto/Kconfig"
> > >
> > > +source "arch/s390/crypto/Kconfig"
> > > +
> >
> > With this there's no dependency on CRYPTO_HW anymore.
> >
> 
> Anyhow "if CRYPTO_HW" is not working in drivers/crypto/Kconfig
> 
> have you tested this patch on S390. Is this giving errors ?
> 
> And you can also add depends with CRYPTO_HW in arch/s390/crypto/Kconfig

Jan just created a patch which moves everything from arch/s390/crypto/Kconfig
to drivers/crypto/Kconfig. Probably will be merged during the 2.6.25 merge
window.
