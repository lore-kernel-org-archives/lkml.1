Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbXJXJAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbXJXJAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 05:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXJXJAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 05:00:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXJXJAF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 05:00:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Date: Wed, 24 Oct 2007 10:55:41 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, matthew@wil.cx, ralf@linux-mips.org,
       adobriyan@gmail.com, viro@ftp.linux.org.uk, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <E1IkAWI-0006vX-00@gondolin.me.apana.org.au> <471EA9D6.9000004@garzik.org>
In-Reply-To: <471EA9D6.9000004@garzik.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200710241055.42567.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/kfZyOIhHDN97F021B2ueJGbDRah2F8JPdndc
 0FyO/qENd2Vpx05DXBK24dJd6OGM0iQ+h/2IKAsZ0HmhSXbtjq
 hkuEthfNJxTNVZziQHPTA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007, Jeff Garzik wrote:
> > 
> > Could we add a debug option that warned if spin_lock_irq is
> > executed with IRQs turned off already?
> 
> Seems reasonable but perhaps arch-specific?
> 
> Also, I think someone (akpm?) mentioned an effort had been made before, 
> and run into some problems.  I don't have details...

I already posted a patch in this thread that does exactly that (and
warn about spin_unlock_irq with IRQs enabled), see my earlier reply.
The patch works fine, but my feeling is that it belongs into lockdep
instead.

	Arnd <><
