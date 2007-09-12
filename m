Return-Path: <linux-kernel-owner+w=401wt.eu-S933172AbXILI4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172AbXILI4j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761563AbXILI4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:56:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50524 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761955AbXILI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:56:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 09/15] Internal __spufs_get_foo() routines should take a spu_context *
Date: Wed, 12 Sep 2007 10:53:02 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Michael Ellerman <michael@ellerman.id.au>, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au> <6e0eb3cefccb1e79c306afd10604f478069d768d.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <6e0eb3cefccb1e79c306afd10604f478069d768d.1189583010.git.michael@ellerman.id.au>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121053.02675.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18c/iYiBZbbBhhxIP5TJAsJRlnvcwd8QdOte3A
 HWTZWtDNwPx675pBYIpGjmdHoXtSK807zQ3WYXArne8JmIhdbf
 Iu7dJH9d0Gnfwpf8YgttQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007, Michael Ellerman wrote:
> The SPUFS attribute get routines take a void * because the generic attribute
> code doesn't know what sort of data it's passing around.
> 
> However our internal __spufs_get_foo() routines can take a spu_context *
> directly, which saves plonking it in and out of a void * again.
> 
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
