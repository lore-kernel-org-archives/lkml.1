Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbXI0Llt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbXI0Llt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbXI0Lll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:41:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51053 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbXI0Llk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:41:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 3/5] ibmebus: Add device creation and bus probing based on of_device
Date: Thu, 27 Sep 2007 13:27:04 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Joachim Fenkes <fenkes@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>, Thomas Klein <tklein@de.ibm.com>,
       Paul Mackerras <pmac@au1.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200709261143.24735.fenkes@de.ibm.com> <200709261145.22278.fenkes@de.ibm.com>
In-Reply-To: <200709261145.22278.fenkes@de.ibm.com>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709271327.05793.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19cf8YdIF+U7cvGsnXzKP10Ww3mladhCNnsRSl
 E6CFgEXG7r8iMH1vgsuBOp37pt1r5AIR5lD520Y6AVsdwFJrzB
 68IE5tQn3mB2VIphXm2rg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2007, Joachim Fenkes wrote:
> The devtree root is now searched for devices matching a built-in whitelist
> during boot, so these devices appear on the bus from the beginning. It is
> still possible to manually add/remove devices to/from the bus by using the
> probe/remove sysfs interface. Also, when a device driver registers itself,
> the devtree is matched against its matchlist.
> 
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
