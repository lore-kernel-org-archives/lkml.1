Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZEAJSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZEAJSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 05:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZEAJSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 05:18:42 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:59781 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZEAJSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 05:18:42 -0400
Date: Fri, 1 May 2009 06:18:04 -0300
From: =?utf-8?Q?Rog=C3=A9rio?= Brito <rbrito@users.sf.net>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Michael Tokarev <mjt@tls.msk.ru>, Mark Lord <lkml@rtr.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090501091804.GB29466@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br> <200904211459.26965.bzolnier@gmail.com> <20090423055618.GA23042@ime.usp.br> <200904232331.13729.bzolnier@gmail.com> <6540c930904232000t76aa4954l4f5cee5bad64aacb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6540c930904232000t76aa4954l4f5cee5bad64aacb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bart and other people.

On Apr 24 2009, Rogério Brito wrote:
> On 4/23/09, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> > You can try booting with "libata.force=1.00:mwdma2" kernel paramater
> > to force use of "regular" MWDMA2 transfer mode instead of UDMA ones
> > so we are sure that the issue is specific to pata_pdc202xx_old +
> > UDMA.
> 
> This *did* work. I see no other error messages, while using multword
> dma. So I think that this serves for us to rule out some unknown
> variables.

Is there anything that I can do right now? Just to remember, the
original IDE driver works without any problems, but I would like to
migrate everything to libata (and many distributions are already using
libata by default, even with IDE devices).


Thanks, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
