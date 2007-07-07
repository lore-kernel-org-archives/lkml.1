Return-Path: <linux-kernel-owner+w=401wt.eu-S1752529AbXGGSPI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbXGGSPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 14:15:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXGGSO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 14:14:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:52493 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbXGGSO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 14:14:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Date: Sat, 7 Jul 2007 20:07:10 +0200
User-Agent: KMail/1.9.6
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070707094852.9473.21013.stgit@localhost.localdomain> <200707071419.52650.arnd@arndb.de> <468FC4AC.9030701@ru.mvista.com>
In-Reply-To: <468FC4AC.9030701@ru.mvista.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707072007.10448.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18UzfamQu6eQ7SYgiQ9lycvJa/Wnkt+eIY386a
 Yz/f2eQwsR9dJczz2X5URnBUIN79uBWBDyHUzd23r+F6xd8nwI
 EUiRFaWhzPzlbJUKo2GWQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007, Sergei Shtylyov wrote:
> Arnd Bergmann wrote:
> 
> >>This adds support for MMIO IDE device like CompactFlash 
> >>in TrueIDE mode.
> 
> >>Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com> 
> >>Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>
> 
> > Hmm, are we still adding new IDE drivers? Do you also have a
> 
>     Yes, why not?

The last time someone (I think Akira Iguchi) wanted to add
a new powerpc specific IDE driver, that was rejected based
on the argument that drivers/ide/ is going away soon. Most
current distros have already moved over to using libata
exclusively.

> > about to add the electra_ide.c driver in 2.6.23, I guess there
> > should really be _one_ driver that is able to handle all
> > of_device based ATA hosts.
> 
>     One driver to rule them all. :-)
>     That may be not so simple as it seems...

It's certainly not easy to support all ATA chips that
have special capabilities and bugs, but the electra and the
mpc8349-itx both seem to support only the most basic ATA
PIO mode anyway, which does not require much special
handling beyond finding the right mmio addresses.

	Arnd <><
