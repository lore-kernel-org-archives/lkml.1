Return-Path: <linux-kernel-owner+w=401wt.eu-S1031050AbXD1RPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031050AbXD1RPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756492AbXD1ROm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:14:42 -0400
Received: from dns1.vpop.net ([216.193.240.2]:61738 "EHLO mail.vpop.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488AbXD1ROl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:14:41 -0400
In-Reply-To: <20070428045018.ff1260da.akpm@linux-foundation.org>
References: <20070424100203.GB16473@2ka.mipt.ru> <20070425174643.f1fc189d.akpm@linux-foundation.org> <50E54C86-53FA-4FEE-83ED-AB0BF2E56F48@vpop.net> <20070428045018.ff1260da.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-1--242703432
Message-Id: <7DC5A400-017E-4478-922D-1648E4F1F098@vpop.net>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
From: Matt Reimer <mreimer@vpop.net>
Subject: Re: [2/2] Driver for the Maxim DS1WM, a 1-wire bus master ASIC core.
Date: Sat, 28 Apr 2007 10:14:35 -0700
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-1--242703432
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	delsp=yes;
	format=flowed

On Apr 28, 2007, at 4:50 AM, Andrew Morton wrote:

> i386 `make allmodconfig' has a few issues.
>
> ERROR: "clk_get" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_put" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_disable" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_enable" [drivers/w1/masters/ds1wm.ko] undefined!
> ERROR: "clk_get_rate" [drivers/w1/masters/ds1wm.ko] undefined!

Attached is a patch to fix this. AFAIK only ARM platforms presently  
use DS1WM and implement linux/clk.h.

Matt


--Apple-Mail-1--242703432
Content-Transfer-Encoding: quoted-printable
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name=0001-Make-CONFIG_MASTER_DS1WM-depend-on-ARM.patch
Content-Disposition: attachment;
	filename=0001-Make-CONFIG_MASTER_DS1WM-depend-on-ARM.patch

=46rom=2061511610faf651adc9d09311f4f054737d1a68d8=20Mon=20Sep=2017=20=
00:00:00=202001=0AFrom:=20Matt=20Reimer=20<mreimer@vpop.net>=0ADate:=20=
Sat,=2028=20Apr=202007=2010:11:35=20-0700=0ASubject:=20[PATCH]=20Make=20=
CONFIG_MASTER_DS1WM=20depend=20on=20ARM=0A=0AMake=20CONFIG_MASTER_DS1WM=20=
depend=20on=20ARM=20as=20that's=20apparently=20the=20only=0Aother=20=
platform=20that=20implements=20linux/clk.h,=20and=20as=20far=20as=20I=20=
know,=20is=0Athe=20only=20other=20platform=20presently=20using=20DS1WM.=0A=
=0ASigned-off-by:=20Matt=20Reimer=20<mreimer@vpop.net>=0A---=0A=20=
drivers/w1/masters/Kconfig=20|=20=20=20=202=20+-=0A=201=20files=20=
changed,=201=20insertions(+),=201=20deletions(-)=0A=0Adiff=20--git=20=
a/drivers/w1/masters/Kconfig=20b/drivers/w1/masters/Kconfig=0Aindex=20=
cad5c54..8f77933=20100644=0A---=20a/drivers/w1/masters/Kconfig=0A+++=20=
b/drivers/w1/masters/Kconfig=0A@@=20-37,7=20+37,7=20@@=20config=20=
W1_MASTER_DS2482=0A=20=0A=20config=20W1_MASTER_DS1WM=0A=20=09tristate=20=
"Maxim=20DS1WM=201-wire=20busmaster"=0A-=09depends=20on=20W1=0A+=09=
depends=20on=20W1=20&&=20ARM=0A=20=09help=0A=20=09=20=20Say=20Y=20here=20=
to=20enable=20the=20DS1WM=201-wire=20driver,=20such=20as=20that=0A=20=09=20=
=20in=20HP=20iPAQ=20devices=20like=20h5xxx,=20h2200,=20and=20ASIC3-based=20=
like=0A--=20=0A1.5.1.1=0A=0A=

--Apple-Mail-1--242703432--
