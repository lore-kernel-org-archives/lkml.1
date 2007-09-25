Return-Path: <linux-kernel-owner+w=401wt.eu-S1756652AbXIYOg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbXIYOg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756253AbXIYOgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:36:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:56155 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbXIYOgc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:36:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/5] PowerPC: Move of_device allocation into of_device.[ch]
Date: Tue, 25 Sep 2007 16:27:57 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>, Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709251410.29780.fenkes@de.ibm.com> <200709251411.27755.fenkes@de.ibm.com>
In-Reply-To: <200709251411.27755.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709251627.59040.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19ZoisxodqeX61wBDm2MrIdBvsYuUY15clQfEX
 hrvyLKpAL16bXOtFeV/LNF7Rsx0aWOqrQ6YBN+ImEeBZIHclRP
 ufQwL5zBWZe72jpA65Nqg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2007, Joachim Fenkes wrote:
> Extract generic of_device allocation code from of_platform_device_create()
> and move it into of_device.[ch], called of_device_alloc(). Also, there's now
> of_device_free() which puts the device node.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
>  include/asm-powerpc/of_device.h   |    4 ++
>  include/linux/of_device.h         |    5 ++
>  arch/powerpc/kernel/of_device.c   |   80 +++++++++++++++++++++++++++++++++++++
>  arch/powerpc/kernel/of_platform.c |   70 +-------------------------------
>  4 files changed, 91 insertions(+), 68 deletions(-)
> 

Sorry I didn't review the patches earlier when you sent them in private.
The patch looks good to me, especially since you did exactly what I
suggested ;-)

Maybe the description should have another sentence in it about what
the change is good for. You have that in the 0/5 mail, but that does
not go into the changelog, so the information gets lost in the process.

	Arnd <><
