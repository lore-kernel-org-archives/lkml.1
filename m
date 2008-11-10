Return-Path: <linux-kernel-owner+w=401wt.eu-S1755509AbYKJNra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbYKJNra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 08:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYKJNrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 08:47:21 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:53829 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbYKJNrV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 08:47:21 -0500
Subject: Re: Bootup time regression from 2.6.27 to 2.6.28-rc3+
From: Yves-Alexis Perez <corsac@debian.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       elendil@planet.nl
In-Reply-To: <20081109132438.5d81cd74@infradead.org>
References: <20081104173300.GF6134@ics.muni.cz> <20081109105159.GA5867@joi>
	 <20081109113304.GE4353@ics.muni.cz> <200811091424.10943.rjw@sisk.pl>
	 <20081109200918.GA4361@ics.muni.cz> <20081109122835.10f410fa@infradead.org>
	 <20081109203432.GB4361@ics.muni.cz> <20081109132438.5d81cd74@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q2hWhwloi03egCp/mkLv"
Date: Mon, 10 Nov 2008 14:45:50 +0100
Message-Id: <1226324750.4212.2.camel@hidalgo>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q2hWhwloi03egCp/mkLv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On dim, 2008-11-09 at 13:24 -0800, Arjan van de Ven wrote:
> On Sun, 9 Nov 2008 21:34:32 +0100
> Lukas Hejtmanek <xhejtman@ics.muni.cz> wrote:
>=20
> > On Sun, Nov 09, 2008 at 12:28:35PM -0800, Arjan van de Ven wrote:
> > > for me, the plan is that we need to get Thomas' fixes tested by
> > > someone who can reproduce this very reliably. If they fix it, great.
> >=20
> > as for me, 100% of boots require a key hit to proceed in 2.6.28-rc3
> > (more precisely, the current git head).
> >=20
>=20
> it would be greatly appreciated if those that see this issue can test
> the patch below (which is a combo patch of thomas' fixes, to make
> testing easier) and confirm if this fixes the hangs.
> If they do fix the issue we don't need to disable anything and get better=
 power
> savings as bonus as well.

Under 2.6.28-rc4 the bootime seems ok, but I have way too much powertop
wakups:

corsac@hidalgo: sudo powertop -d
PowerTOP 1.10    (C) 2007, 2008 Intel Corporation=20

Collecting data for 15 seconds=20


Cn                Avg residency
C0 (cpu running)        ( 4,3%)
C0                0,0ms ( 0,0%)
C1                0,0ms ( 0,0%)
C2                0,5ms ( 0,3%)
C4                2,8ms (95,5%)
P-states (frequencies)
  2,21 Ghz     1,3%
  2,21 Ghz     0,0%
  1,60 Ghz     0,5%
   800 Mhz    98,1%
Wakeups-from-idle per second : 346,5	interval: 15,0s
Power usage (ACPI estimate): 15,1W (1,6 hours)=20
Top causes for wakeups:
  74,1% (278,5)       <interrupt> : extra timer interrupt=20
   8,8% ( 33,2)      <kernel IPI> : Rescheduling interrupts=20
   4,1% ( 15,3)       <interrupt> : uhci_hcd:usb5, yenta,
i915@pci:0000:00:02.0=20
   3,6% ( 13,7)       <interrupt> : iwlagn=20
   1,7% (  6,5)       <interrupt> : acpi=20
   1,1% (  4,1)   <kernel module> : usb_hcd_poll_rh_status
(rh_timer_func)=20
   1,0% (  3,9)       <interrupt> : ahci=20

Cheers,
--=20
Yves-Alexis

--=-q2hWhwloi03egCp/mkLv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkYOwgACgkQTUTAIMXAW67PrACfbRNHIwcS/a3ZcrdZleGos+CX
F2oAnjc8SEDfYS3/0tuJ9X7ACehu8j90
=C2q1
-----END PGP SIGNATURE-----

--=-q2hWhwloi03egCp/mkLv--
