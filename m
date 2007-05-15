Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbXEOJwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbXEOJwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759438AbXEOJwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:52:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:58102 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758936AbXEOJwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:52:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] pasemi: Electra CF driver
Date: Tue, 15 May 2007 11:52:23 +0200
User-Agent: KMail/1.9.6
Cc: Olof Johansson <olof@lixom.net>, paulus@samba.org,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20070515044515.GA6731@lixom.net>
In-Reply-To: <20070515044515.GA6731@lixom.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705151152.23940.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/DRxU8eiw97Wq5+QUwYqH3Xq7IjMLGTbQoz+L
 ZRdVITETQoMg8ppSN7deIBxYMtRkTaIoqwEKSz6k6yWn8x+MMD
 LV+vcw4Sn+S1geHJncCAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 May 2007, Olof Johansson wrote:
> Driver for the CompactFlash slot on the PA Semi Electra eval board. It's
> a simple device sitting on localbus, with interrupts and detect/voltage
> control over GPIO.

The driver looks really good, there is nothing for me to complain about.

> The driver is implemented as an of_platform driver, and adds localbus
> as a bus being probed by the of_platform framework.

I supposed "localbus" is what the current firmware ships with in the
device tree, right? If you still have the choice on how this is
represented it might be better not to invent another device-type
but rather make this "soc" or whatever existing type we know about.

	Arnd <><
