Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYHDJHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYHDJHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYHDJG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:06:58 -0400
Received: from mx2.schottelius.org ([62.65.138.77]:37903 "EHLO
	mx2.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbYHDJG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:06:57 -0400
Date: Mon, 4 Aug 2008 11:06:54 +0200
From: Nico Schottelius 
	<nico-linux-kernel-bugreport20080731@schottelius.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: Heavy suspend and io problems in 2.6.27-rc1-00156-g94ad374
Message-ID: <20080804090654.GA4747@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-kernel-bugreport20080731@schottelius.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
References: <20080731210507.GA6094@denkbrett.schottelius.org> <200807312349.47817.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nq2Wo0NMKNjxTN9z"
Content-Disposition: inline
In-Reply-To: <200807312349.47817.rjw@sisk.pl>
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: denkbrett (Linux 2.6.26-next-20080725-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Rafael!

I tested the patch and also linux-next-20080801:

   linux-next-20080801: does not wake up
   linux-next-20080801+patch: wakes up, console keeps on being black
      -> no xorg running, as it cannot be run due to synaptics bug
         (fixed in git, not in debian lenny packages)

So I was able to type "reboot" when running the patch, while I had to
force power-off on the main linux-next-tree.

I am back on 2.6.26-next-20080725, which suspends and wakes up fine.

Sincerly,

Nico

Rafael J. Wysocki [Thu, Jul 31, 2008 at 11:49:47PM +0200]:
> On Thursday, 31 of July 2008, Nico Schottelius wrote:
> > Hello=A1
> >=20
> > I've some serious problems with this kernel on the ibm t60:
> >=20
> > - wake up from suspend takes about 30 seconds
> > - i need to switch to console and back to see xorg screen again (before:
> >   only black)
> > - after wake up, I get disk input/output errors, no access to sda is
> >   possible
> >=20
> > As I could not do any dumps I took photos of the dmesg output with my
> > camera and put them in high resolution to
> >=20
> >    http://home.schottelius.org/~nico/unix/linux/kernel/2.6.27-rc1-00156=
-g94ad374/
>=20
> Can you test the fix in http://bugzilla.kernel.org/show_bug.cgi?id=3D1117=
8, please?
>=20
> Thanks,
> Rafael

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--Nq2Wo0NMKNjxTN9z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiWxq4ACgkQuL75KpiFGIwMpgCgz7RhXNJ6mePSKLffQbG8J3ti
C3UAoL9I6WWFvZXoyHIG5MULo+jzhQ9V
=O6Zs
-----END PGP SIGNATURE-----

--Nq2Wo0NMKNjxTN9z--
