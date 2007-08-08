Return-Path: <linux-kernel-owner+w=401wt.eu-S935372AbXHHXBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935372AbXHHXBm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 19:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbXHHXBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 19:01:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:61844 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572AbXHHXBa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 19:01:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@logfs.org>
Subject: Re: [Patch 16/18] fs/Kconfig
Date: Thu, 9 Aug 2007 01:01:26 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070808161234.GB15319@lazybastard.org> <20070808162339.GR15319@lazybastard.org>
In-Reply-To: <20070808162339.GR15319@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708090101.27226.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ZDQBwwzsCfDOg8Q9S2UWRx6phUIOzU46Dmue
 ETrBMNCXKTDIBUh3kIzvNAt64xkiUe6EFNHQzlKC0hADgkFPN7
 H2+NqON1f7sb8KvwZ6t4A==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 August 2007, Jörn Engel wrote:
> +config LOGFS
> +       bool "Log Filesystem (EXPERIMENTAL)"
> +       depends on MTD && BLOCK && EXPERIMENTAL

The dependency on MTD _and_ BLOCK looks correct for your code, but
not necessary. How about making it 

	depends on (MTD || BLOCK) && EXPERIMENTAL

and allowing to build without the mtd/bdev specific code?

	Arnd <><
