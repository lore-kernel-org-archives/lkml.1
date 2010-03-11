Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab0CKU7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:59:36 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:45265 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab0CKU7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:59:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jx0h6meM4akL07RgXr24WTDhI2zSlifU9GyIISQ+EMlK0+2nl3THc8212TY2D2MIxa
         +P0IOjXO4RNjDcGUkM/ChmT69mZwhWYaka4KoihsdWLRzJFSgr/iZK/C5lH0mLTv/s7Q
         mUJVNIsFJRcnQyOTqrGbzQ+v2ZtB4d4R5QbLk=
Subject: Re: [PATCH -next] mtd/nand/r852: fix build for CONFIG_PCI disabled
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org
In-Reply-To: <4B992408.7040608@oracle.com>
References: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
	 <4B8C378B.2090400@oracle.com> <1267531329.10734.1.camel@maxim-laptop>
	 <4B991A6F.1080006@oracle.com> <4B991B9B.8070809@oracle.com>
	 <4B992408.7040608@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Mar 2010 22:59:29 +0200
Message-ID: <1268341169.9708.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-11 at 09:10 -0800, Randy Dunlap wrote:
> > 
> > Sorry, it's there, but there are still build errors.
> > I will look at those...
> > 
> 
> 
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> r852 fails to build when CONFIG_PCI is not enabled since it uses
> pci_*() calls and is a PCI driver, so it should depend on PCI
> to prevent build errors.
> It should also #include <linux/pci.h>.


Folks, sorry for Kconfig mess, I didn't test it well enough it seems...

However, I #include the <linux/pci.h> in r852.h, so I don't think it is
necessary here.


Also, I disagree with the unconditional dependency on nand in sm_ftl.
The purpose of CONFIG_SM_FTL_MUSEUM is solely to make it independent of
nand. I'll look at how to fix that properly.



Best regards,
	Maxim Levitsky

