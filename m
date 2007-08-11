Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbXHKSkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbXHKSkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755953AbXHKSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:40:33 -0400
Received: from mx28.mail.ru ([194.67.23.67]:33036 "EHLO mx28.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbXHKSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:40:31 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sat, 11 Aug 2007 22:39:35 +0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706301116.19501.arvidjaar@mail.ru> <200706300545.43181.bjorn.helgaas@hp.com>
In-Reply-To: <200706300545.43181.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10892948.fJBhMzST4Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708112239.37475.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10892948.fJBhMzST4Y
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 30 June 2007, Bjorn Helgaas wrote:
> On Saturday 30 June 2007 01:16:18 am Andrey Borzenkov wrote:
> > > This patch fixes the 2.6.22 regression:
> > >     "no irda0 interface (2.6.21 was OK), smsc does not find chip"
> >
> > does not work, sorry.
>
> Sigh ;-)  Thanks for your patience in dealing with this.
>

This stopped working again in 2.6.23-rc. In 2.6.22 we decided to disable Pn=
P=20
by default; it is apparently enabled now and fails to activte IrDA=20
completely. So it moves to post-2.6.22 regressions :)

let me know which information you need

[ 2192.666450] pnp: PnP ACPI init
[ 2192.666589] ACPI: bus type pnp registered
[ 2192.686035] pnp: Device 00:0a activated.
[ 2192.686089]  00:0a: SMCf010 not responding at SIR 0x100, FIR 0x2e8;=20
auto-configuring
[ 2192.687610] pnp: Device 00:0a disabled.
[ 2192.693179] pnp: Device 00:0a activated.
[ 2192.693210]  00:0a: not responding at SIR 0x100, FIR 0x2e8; swapping=20
SIR/FIR and reconfiguring
[ 2192.694720] pnp: Device 00:0a disabled.
[ 2192.701232] pnp: Device 00:0a activated.
[ 2192.701259]  00:0a: responds at SIR 0x2e8, FIR 0x100
[ 2192.709309] pnp: PnP ACPI: found 12 devices
[ 2192.709351] ACPI: ACPI bus type pnp unregistered

=2E...

[ 2207.986550] Detected unconfigured Toshiba laptop with ALi ISA bridge SMS=
C=20
IrDA chip, pre-configuring device.
[ 2207.986587] Activated ALi 1533 ISA bridge port 0x02e8.
[ 2207.986602] Activated ALi 1533 ISA bridge port 0x02f8.
[ 2207.986817] found SMC SuperIO Chip (devid=3D0x5a rev=3D00 base=3D0x002e)=
:=20
LPC47N227
[ 2207.986851] smsc_superio_flat(): fir: 0x2f8, sir: 0x2e8, dma: 03, irq: 7=
,=20
mode: 0x0e
[ 2207.986873] smsc_ircc_present: can't get sir_base of 0x2e8



--nextPart10892948.fJBhMzST4Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGvgJpR6LMutpd94wRAixZAKCHIwScbmkgyqlfbYpGnfy1cfaKawCcC9wW
HpzxDORT131yuEnzS0JBCM4=
=FM0g
-----END PGP SIGNATURE-----

--nextPart10892948.fJBhMzST4Y--
