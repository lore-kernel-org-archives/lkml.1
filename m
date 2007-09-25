Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbXIYOia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbXIYOia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756319AbXIYOiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:38:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63221 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbXIYOiT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:38:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/5] ibmebus: Remove bus match/probe/remove functions
Date: Tue, 25 Sep 2007 16:29:51 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>, Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709251410.29780.fenkes@de.ibm.com> <200709251411.54465.fenkes@de.ibm.com>
In-Reply-To: <200709251411.54465.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709251629.52376.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+E6nTSfsgwLeufR6EjfadQVzW6wni/OeLYwAd
 f9MSTcCXTA7W4LBzDr7oyGr67mrNIg2z4SovK00zVW2B125UTX
 VUFpaPUIA7DwPJVQXoZ7w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 September 2007, Joachim Fenkes wrote:
> ibmebus_{,un}register_driver() are replaced by dummy functions because
> ibmebus is temporarily unusable in this transitional state.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
>  arch/powerpc/kernel/ibmebus.c |  199 ++---------------------------------------
>  1 files changed, 6 insertions(+), 193 deletions(-)
> 

Great diffstat!

The description makes it sound like a git-bisect would get broken
by this patch, which should never happen. If the patch indeed
ends up with a broken kernel, it would be better to merge it with
the later patch that fixes the code again.

	Arnd <><
