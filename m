Return-Path: <linux-kernel-owner+w=401wt.eu-S933416AbXILI7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416AbXILI7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 04:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762213AbXILI7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 04:59:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:64867 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXILI7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 04:59:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 08/15] Use spufs_coredump_num_notes everywhere, and don't NULL terminate
Date: Wed, 12 Sep 2007 10:55:39 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070831.706792)
Cc: Michael Ellerman <michael@ellerman.id.au>, Jeremy Kerr <jk@ozlabs.org>,
       linux-kernel@vger.kernel.org
References: <2900ea4dbfd6e98e71ff400cbd25d1283a278972.1189583010.git.michael@ellerman.id.au> <163f3c08c2c47d47103f234d6caa517ed9a44036.1189583010.git.michael@ellerman.id.au>
In-Reply-To: <163f3c08c2c47d47103f234d6caa517ed9a44036.1189583010.git.michael@ellerman.id.au>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709121055.40170.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/kjOxXFA+fh+O3UCtJbhr3g2EG+pyscXjGqzT
 kudzUGlGpKRH4n6QlKVGHWYevR6rb6yqEzKjNc5Egnl8Kzmjp8
 Nppda2ckxUoRsmR29iBlw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 September 2007, Michael Ellerman wrote:
> The spufs_coredump_read array is NULL terminated, and we also store the size.
> We only need one or the other, and storing the size should save a teensy bit
> of memory vs NULL terminating, so do that.

Given that we have another array in there with almost the same contents
and that is NULL terminated, I'd vote for doing it the other way and also
use NULL-termination instead of the count here.

	Arnd <><
