Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbXGGMWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbXGGMWY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 08:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXGGMWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 08:22:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:49933 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXGGMWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 08:22:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] [ide] mmio ide support
Date: Sat, 7 Jul 2007 14:19:52 +0200
User-Agent: KMail/1.9.6
Cc: Vitaly Bordug <vitb@kernel.crashing.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20070707094852.9473.21013.stgit@localhost.localdomain>
In-Reply-To: <20070707094852.9473.21013.stgit@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707071419.52650.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19hFk8FoRyDv0iSnpNiFh2hyzdCzgfv2Z2cQv3
 7ERENezcWOroP0QpxNZ4AfGq3Tq6EnFvqkpE0KmU0XzpSNg7fB
 s+qcEEHACISsbnNaO4gRQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007, Vitaly Bordug wrote:
> 
> This adds support for MMIO IDE device like CompactFlash 
> in TrueIDE mode.
>  
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com> 
> Signed-off-by: Vitaly Bordug <vitb@kernel.crashing.org>

Hmm, are we still adding new IDE drivers? Do you also have a
driver for the new libata layer? I think it would even be
simpler to do.

You could also make it an of_platform_driver at the same time
instead of adding more cruft to fsl_soc.c. Since we're already
about to add the electra_ide.c driver in 2.6.23, I guess there
should really be _one_ driver that is able to handle all
of_device based ATA hosts.

	Arnd <><
