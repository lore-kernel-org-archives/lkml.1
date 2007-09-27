Return-Path: <linux-kernel-owner+w=401wt.eu-S1751750AbXI0LmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbXI0LmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbXI0Llm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:41:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXI0Llk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:41:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/5] PowerPC: Move of_device allocation into of_device.[ch]
Date: Thu, 27 Sep 2007 13:27:41 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709261143.24735.fenkes@de.ibm.com> <200709261144.14282.fenkes@de.ibm.com>
In-Reply-To: <200709261144.14282.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271327.42781.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18N4r+hoQLi33jXyQbhB/fSNR2Va3FB6b23z6W
 reKdNJjiV/VPMgIW7HvVzjlp1WesZBQ3DGM5Kyf5T84RENpiAj
 Q0BoI3GntO6VPcNBtf3Yw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007, Joachim Fenkes wrote:
> Extract generic of_device allocation code from of_platform_device_create()
> and move it into of_device.[ch], called of_device_alloc(). Also, there's now
> of_device_free() which puts the device node.
> 
> This way, bus drivers that build on of_platform (like ibmebus will) can
> build upon this code instead of reinventing the wheel.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
