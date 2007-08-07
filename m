Return-Path: <linux-kernel-owner+w=401wt.eu-S938292AbXHGWNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938292AbXHGWNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 18:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938214AbXHGWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 18:08:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938216AbXHGWIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 18:08:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] powerpc: Use linux/elfcore-compat.h
Date: Wed, 8 Aug 2007 00:08:20 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070803232321.74DB84D04BC@magilla.localdomain>
In-Reply-To: <20070803232321.74DB84D04BC@magilla.localdomain>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708080008.20738.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QIhyCTAEJ89zT/lD4lzZEGmccUd3DQxsmRnB
 hIxoaCISYpI9Gi7hQ89Gn4PvGJPrI21ln+R4v8CeCzrOLpVaqa
 6yEhlz2vLhQfVuDFc63oA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 04 August 2007, Roland McGrath wrote:
> 
> This makes powerpc64's compat code use the new linux/elfcore-compat.h,
> reducing some hand-copied duplication.

There is hardly anything interesting remaining in 
arch/powerpc/kernel/binfmt_elf32.c after your patch.

Do you think it's reasonable to go one step further and
turn the file into a completely generic fs/binfmt_elf32.c
that can be used by all 32/64 compat architectures?

I tried that in the past, but failed because I don't
really understand enough of the ELF loader to know
which architectures do it right and which don't -- I only
saw them all being very different in this file ;-)

	Arnd <><
