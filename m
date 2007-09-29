Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXI2Qh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXI2Qh6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 12:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbXI2Qhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 12:37:52 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:38118 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754986AbXI2Qhw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 12:37:52 -0400
From: Florian Schmidt <mista.tapas@gmx.net>
To: linux-kernel@vger.kernel.org
Subject: Re: getting FUSD compiled with current kernels
Date: Sat, 29 Sep 2007 18:37:51 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200709291823.35868.mista.tapas@gmx.net> <200709291835.15489.mista.tapas@gmx.net>
In-Reply-To: <200709291835.15489.mista.tapas@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709291837.51976.mista.tapas@gmx.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 September 2007, Florian Schmidt wrote:
> On Saturday 29 September 2007, Florian Schmidt wrote:
> > Hi,
> >
> > I'm trying to build FUSD [1] against current kernels [2.6.22]. I get
> > errors [2]:
>
> Oh i forgot to show the code snippets in question. I put them to the

Oh and i also forget to mention that i get the same errors when using:

KDIR=/usr/src/linux-source-2.6.22/ make

[Where the ubuntu kernel package put the source. I configured it with the 
default ubuntu .config and make oldconfig]. I get one more message though:

~/source/build_stuff/fusd/kfusd$ KDIR=/usr/src/linux-source-2.6.22/ make
make -C /usr/src/linux-source-2.6.22/ 
SUBDIRS=/home/tapas/source/build_stuff/fusd/kfusd 
EXTRA_CFLAGS=-I/home/tapas/source/build_stuff/fusd/kfusd/../include modules
make[1]: Entering directory `/usr/src/linux-source-2.6.22'

  WARNING: Symbol version dump /usr/src/linux-source-2.6.22/Module.symvers
           is missing; modules will have no dependencies and modversions.

  CC [M]  /home/tapas/source/build_stuff/fusd/kfusd/kfusd.o
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c: In function ‘to_kobj’:
/home/tapas/source/build_stuff/fusd/kfusd/kfusd.c:135: error: dereferencing 
pointer to incomplete type
[...]

Regards,
Flo



-- 
Palimm Palimm!
http://tapas.affenbande.org
