Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbXFQXZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbXFQXZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759535AbXFQXYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:24:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:50457 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756550AbXFQXYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:24:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] use __asm__ and __volatile__ in i386/arm/s390 byteorder.h
Date: Mon, 18 Jun 2007 01:24:24 +0200
User-Agent: KMail/1.9.6
Cc: Mike Frysinger <vapier@gentoo.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       rmk@arm.linux.org.uk
References: <200706171833.29046.vapier@gentoo.org> <1182120674.22999.4.camel@laptopd505.fenrus.org>
In-Reply-To: <1182120674.22999.4.camel@laptopd505.fenrus.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706180124.25574.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19QUhdJs89InPoxG5/ft3MstMXmTMC6wAOBLdt
 1t+OwE+xCaZSIvKhTMw/LjN3wQ559lueqmAvvNPLM6PgQFHrx9
 P8tUwQ7rAay1r+a56TfLQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 June 2007, Arjan van de Ven wrote:
> 
> On Sun, 2007-06-17 at 18:33 -0400, Mike Frysinger wrote:
> > This changes asm() to __asm__() and volatile to __volatile__ so that these
> > headers can be used with gcc's -std=c99.
> 
> hmm but the kernel doesn't use -std=c99...

The byteorder headers are exported to user space through
include/asm-generic/Kbuild.asm, and they are used by a number
of other exported headers, so they should work with any
gcc flags that a user might want to use.

	Arnd <><
