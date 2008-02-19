Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYBSP7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYBSP7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 10:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbYBSP7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 10:59:45 -0500
Received: from smtp1-g19.free.fr ([212.27.42.27]:51250 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYBSP7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 10:59:44 -0500
Date: Tue, 19 Feb 2008 16:59:40 +0100
From: Thomas Petazzoni <thomas.petazzoni@enix.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: arch/x86/kernel/acpi/sleep_32.c not compiled ?
Message-ID: <20080219165940.6e9348f6@crazy>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/antvKi8R/BcPtjhMLm5Vgem";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/antvKi8R/BcPtjhMLm5Vgem
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

Maybe I'm missing something completely obvious, but I don't see where
the arch/x86/kernel/acpi/sleep_32.c file gets compiled. The Makefile in
that directory compiles sleep.o, but doesn't compile sleep_$(BITS).o:

obj-$(CONFIG_ACPI)              +=3D boot.o
obj-$(CONFIG_ACPI_SLEEP)        +=3D sleep.o wakeup_$(BITS).o

ifneq ($(CONFIG_ACPI_PROCESSOR),)
obj-y                           +=3D cstate.o processor.o
endif

Sincerly,

Thomas
--=20
Thomas Petazzoni, thomas.petazzoni@enix.org, http://thomas.enix.org
Jabber, thomas.petazzoni@jabber.dk
Toulibre, http://www.toulibre.org - APRIL, http://www.april.org
Fingerprint : 0BE1 4CF3 CEA4 AC9D CC6E  1624 F653 CB30 98D3 F7A7

--Sig_/antvKi8R/BcPtjhMLm5Vgem
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuvzs9lPLMJjT96cRAlxqAKC63NSwA5MrJQNwsrKLDS3+IzlbDQCgj0iT
a4U5q1qpo0gtT/u3iKp5Rx4=
=3AiV
-----END PGP SIGNATURE-----

--Sig_/antvKi8R/BcPtjhMLm5Vgem--
