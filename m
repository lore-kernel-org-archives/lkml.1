Return-Path: <linux-kernel-owner+w=401wt.eu-S1753693AbXGHOAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbXGHOAg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 10:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757075AbXGHN74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 09:59:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:48887 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756998AbXGHN7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 09:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fW8yUSrGBzKaVYIvOBqpj5NGzkxA38lFssuNVY3IAkGtm53n40Y52rqUtzhizWOZq0Up3Zx2mG8/bTcI7v7olz101UasT/Kcit/cKClBLv3tbgHXPGK6YTbngJ/9nsjVqRnmDTtH3wcKpaktgVJFz4ZXpVq9iAlo7joVmUN2jr0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Date: Sun, 8 Jul 2007 15:15:41 +0200
User-Agent: KMail/1.9.6
Cc: linuxppc-dev@ozlabs.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20070707094852.9473.21013.stgit@localhost.localdomain> <468FC4AC.9030701@ru.mvista.com> <200707072007.10448.arnd@arndb.de>
In-Reply-To: <200707072007.10448.arnd@arndb.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707081515.42105.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 07 July 2007, Arnd Bergmann wrote:
> On Saturday 07 July 2007, Sergei Shtylyov wrote:
> > Arnd Bergmann wrote:
> > 
> > >>This adds support for MMIO IDE device like CompactFlash 
> > >>in TrueIDE mode.
> > 
> > >>Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com> 
> > >>Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> > 
> > > Hmm, are we still adding new IDE drivers? Do you also have a
> > 
> >     Yes, why not?
> 
> The last time someone (I think Akira Iguchi) wanted to add
> a new powerpc specific IDE driver, that was rejected based

linux/drivers/ide/pci/scc_pata.c

New IDE host drivers are still fine.

> on the argument that drivers/ide/ is going away soon. Most
> current distros have already moved over to using libata
> exclusively.

The in-kernel default for PATA systems is still IDE subsystem.

Thanks,
Bart
