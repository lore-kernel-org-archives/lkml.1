Return-Path: <linux-kernel-owner+w=401wt.eu-S1754684AbXIMMVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684AbXIMMVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 08:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752643AbXIMMVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 08:21:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52205 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbXIMMVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 08:21:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michael@ellerman.id.au
Subject: Re: [PATCH 15/15] Add DEFINE_SPUFS_ATTRIBUTE()
Date: Thu, 13 Sep 2007 14:17:48 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: linuxppc-dev@ozlabs.org, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au> <200709121047.05471.arnd@arndb.de> <1189649141.19087.13.camel@concordia.ozlabs.ibm.com>
In-Reply-To: <1189649141.19087.13.camel@concordia.ozlabs.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709131417.48748.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19YZheWYK0psl+2ZuUS29YTRZcqqnaC0TRTWjT
 EJMZD7OUt6C4Cv59ALpPZjwwbZeEZntSFEGWAJkmny76jleEik
 fgRkOC5VA4eNeso4v4kpQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 September 2007, Michael Ellerman wrote:
> Well that'd be nice, but I don't see anywhere that that happens. AFAICT
> the acquire we do in the first coredump callback is the first the SPU
> contexts know about their PPE process dying. And spufs is still live, so
> I think we definitely need to grab the mutex, or we might race with
> userspace accessing spufs files.

Right, I was only thinking about the dumping process itself, but there
may be other processes that still have files open for that context.

	Arnd <><
