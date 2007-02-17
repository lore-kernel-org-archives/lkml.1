Return-Path: <linux-kernel-owner+w=401wt.eu-S932889AbXBQVAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932889AbXBQVAQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:00:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbXBQVAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:00:16 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:60600 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932889AbXBQVAP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:00:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Subject: Re: [PATCH 10/44 take 2] [UBI] debug unit implementation
Date: Sat, 17 Feb 2007 22:00:11 +0100
User-Agent: KMail/1.9.5
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165514.5845.31845.sendpatchset@localhost.localdomain>
In-Reply-To: <20070217165514.5845.31845.sendpatchset@localhost.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
X-Legal: Vorsitzender des Aufsichtsrats: Johann Weihen=0A=0D Gesch=E4ftsf=FChrung: Herbert Kircher=0A=0D Sitz der Gesellschaft: B=F6blingen=0A=0D Registergericht: Amtsgericht Stuttgart, HRB 243294
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702172200.12910.arnd@arndb.de>
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:c48f057754fc1b1a557605ab9fa6da41
X-Provags-ID2: V01U2FsdGVkX1/oZeRX6mQN0veV9+hEUacQ/QEqf8dURrD+hPJ45FdcGSVakQg7KbSovenk3j4IEnanX0MScxUBjTcZGSdrU/gk5ERTH9PCtq1p36e9tN/70A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 February 2007 17:55, Artem Bityutskiy wrote:
> 
> diff -auNrp tmp-from/drivers/mtd/ubi/debug.c tmp-to/drivers/mtd/ubi/debug.c
> --- tmp-from/drivers/mtd/ubi/debug.c    1970-01-01 02:00:00.000000000 +0200
> +++ tmp-to/drivers/mtd/ubi/debug.c      2007-02-17 18:07:26.000000000 +0200

This whole file looks like it can be removed, as nothing in here
is really relevant for regular operation. I'm sure that much of it
was a good help in developing the code and finding the bugs in here,
but why would you want to merge it into the mainline kernel?

	Arnd <><
