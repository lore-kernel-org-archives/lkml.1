Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbYBMKJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbYBMKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 05:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYBMKJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 05:09:51 -0500
Received: from mail.free-electrons.com ([88.191.46.45]:1073 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYBMKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 05:09:50 -0500
Date: Wed, 13 Feb 2008 11:09:35 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, Linux-tiny@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] x86: Configure out compilation of Simple Boot
 Flag support
Message-ID: <20080213110935.28689262@crazy>
In-Reply-To: <20080213092958.GB25258@elte.hu>
References: <20080213094400.6b7f3446@crazy>
	<20080213092958.GB25258@elte.hu>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/9WRHiMchtT8oEs8ZwbeVI_F";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9WRHiMchtT8oEs8ZwbeVI_F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Wed, 13 Feb 2008 10:29:58 +0100,
Ingo Molnar <mingo@elte.hu> a =C3=A9crit :

> no strong feelings if the ACPI guys ack it - but i suspect the
> renaming of the function from acpi_parse_sbf to sbf_acpi_parse was
> unnecessary?

I rename acpi_parse_sbf() to sbf_acpi_parse() because the function was
moved from arch/x86/kernel/acpi/boot.c, where pretty much all functions
are named acpi_*() to the file arch/x86/kernel/bootflag.c, where all
the functions are named sbf_*(). However, I don't mind reverting that
renaming, I just thought it was cleaner, but I have no strong opinion
on it.

Any thoughts about the duplicate call to
acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf) ?

Thanks for your comments,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/9WRHiMchtT8oEs8ZwbeVI_F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHssHi9lPLMJjT96cRApuNAJ0ZeuzC3tALnPhiSYtW/tE8l+trpwCdEUuc
O0DgLySoXGgHG8KH/8SvxZg=
=Pon8
-----END PGP SIGNATURE-----

--Sig_/9WRHiMchtT8oEs8ZwbeVI_F--
