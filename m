Return-Path: <linux-kernel-owner+w=401wt.eu-S1764772AbXILIzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764772AbXILIzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761208AbXILIy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:54:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61660 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756303AbXILIy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:54:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 11/15] Combine spufs_coredump_calls with spufs_calls
Date: Wed, 12 Sep 2007 10:51:32 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Michael Ellerman <michael@ellerman.id.au>, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au> <5d0eaf2dbfd1046983f3e6f96ff6b8d967ec3801.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <5d0eaf2dbfd1046983f3e6f96ff6b8d967ec3801.1189583010.git.michael@ellerman.id.au>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121051.33187.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX197OhIM6dlgHN15uoMBKbwBf/BML2KRoOynFfV
 +cZrxHHki18kwvRk7+it0o6WC7EzeGAlCZmZ5SYr0M0KfVT4xJ
 4mBk2hPn4n1buoRGsDSHA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007, Michael Ellerman wrote:
> Because spufs might be built as a module, we can't have other parts of the
> kernel calling directly into it, we need stub routines that check first if the
> module is loaded.
> 
> Currently we have two structures which hold callbacks for these stubs, the
> syscalls are in spufs_calls and the coredump calls are in spufs_coredump_calls.
> In both cases the logic for registering/unregistering is essentially the same,
> so we can simplify things by combining the two.

Nice cleanup!

> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>

Acked-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
