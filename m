Return-Path: <linux-kernel-owner+w=401wt.eu-S1754637AbYKLStn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbYKLStn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 13:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYKLStT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 13:49:19 -0500
Received: from mx71.mail.ru ([194.67.23.4]:63941 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbYKLStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 13:49:17 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Attempt rebooting via port CF9 if it seems to be available
Date: Wed, 12 Nov 2008 21:49:10 +0300
User-Agent: KMail/1.9.10
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
       linux-acpi@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Eduardo Habkost <ehabkost@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <007e7d616a5d1c2e16ad627d03f8b97799445e71.1226032943.git.len.brown@intel.com> <alpine.LFD.2.00.0811111802440.4480@localhost.localdomain> <491A225F.4090407@zytor.com>
In-Reply-To: <491A225F.4090407@zytor.com>
MIME-Version: 1.0
Message-Id: <200811122149.11947.arvidjaar@mail.ru>
Content-Type: multipart/signed;
  boundary="nextPart24054807.FlmPopGCp2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart24054807.FlmPopGCp2
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 12 November 2008, H. Peter Anvin wrote:
> Looking at doing the port CF9 fallback, I stumbled onto something fishy.
>=20
> I wonder if anyone here happens to have any idea why we turn off
> caching in machine_real_restart()?  Jumping to the BIOS is *not* a
> reset; we jump to the decompressed BIOS on low memory which is usually
> shadowed, not to the BIOS entry point.  In that way, it's more of an
> INIT than a reset, and disabling caching seems broken.
>=20
> Either way, here is a preliminary patch to do the CF9 if safe, and then
> falling back to keyboard reboot.  I'm a bit concerned about how to test
> it, of course; this stuff is sensitive and just about impossible to test
> except on millions of machines at once...
>=20
> If you have any machines (especially problematic ones) and find that
> this patch either helps or hurts or do nothing, please do let me know so
> I have any idea of the extent of coverage.
>=20

Works here both with default and reboot=3Dp.

--nextPart24054807.FlmPopGCp2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkbJScACgkQR6LMutpd94zQJACcDbLLCdaEG44dUWiOLHkJPxxC
XgIAoMIcqwL+jqCCrensZkqKHP1rNyQy
=xmel
-----END PGP SIGNATURE-----

--nextPart24054807.FlmPopGCp2--
