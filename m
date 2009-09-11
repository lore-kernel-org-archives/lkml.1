Return-Path: <linux-kernel-owner+w=401wt.eu-S1752634AbZIKLHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbZIKLHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZIKLHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:07:04 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:37817 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZIKLHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:07:03 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Sep 2009 07:07:03 EDT
Date: Fri, 11 Sep 2009 13:00:56 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v6][PATCH 8/9]: Define clone_with_pids() syscall
Message-ID: <20090911110056.GA12824@hawkmoon.kerlabs.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
	Containers <containers@lists.linux-foundation.org>,
	Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
	mingo@elte.hu, torvalds@linux-foundation.org,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Pavel Emelyanov <xemul@openvz.org>
References: <20090910060627.GA24343@us.ibm.com> <200909100931.25585.arnd@arndb.de> <20090910212837.GA31459@us.ibm.com> <200909111231.30495.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-29211-1252666815-0001-2"
Content-Disposition: inline
In-Reply-To: <200909111231.30495.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-29211-1252666815-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11/09/09 12:31 +0200, Arnd Bergmann wrote:
> On Thursday 10 September 2009, Sukadev Bhattiprolu wrote:
> > Since this is a variant of clone() and clone is listed as a PTREGSCALL(=
),
> > I pass in the pt_regs.
> >=20
> > arch/x86/kernel/entry_32.S lists clone() under this comment:
> >=20
> > /*
> >  * System calls that need a pt_regs pointer.
> >  */
> >=20
> > Is there a guideline on what system calls use/need pt_regs ?
>=20
> You need pt_regs if you access any registers from the user task
> other than the argument registers. In case of clone(), this is
> the user stack pointer.

AFAICS clone() actually needs _all_ registers (see x86 copy_thread() for
instance). Any variant of clone() will have this requirement.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-29211-1252666815-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqqLegACgkQVKcRuvQ9Q1TSUQCguOM4SiZDaN6vYaxukoMfnggt
xCEAn0ixmZQL/6PoIqEMqLO7lyn+9sBE
=QGGS
-----END PGP SIGNATURE-----

--=_bohort-29211-1252666815-0001-2--
