Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbXJOOqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbXJOOqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018AbXJOOqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:46:09 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:54258 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbXJOOqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:46:07 -0400
Message-ID: <47137D15.7040104@bull.net>
Date: Mon, 15 Oct 2007 16:45:41 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time accounting.
References: <46E550EF.5080209@bull.net> <200710151333.21078.borntraeger@de.ibm.com> <47135150.8040901@bull.net> <200710151639.23614.borntraeger@de.ibm.com>
In-Reply-To: <200710151639.23614.borntraeger@de.ibm.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 16:52:23,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 15/10/2007 16:52:25,
	Serialize complete at 15/10/2007 16:52:25
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig62AD99E413C702373828F710"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig62AD99E413C702373828F710
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Christian Borntraeger wrote:
> Am Montag, 15. Oktober 2007 schrieb Laurent Vivier:
>>> Any idea how to make this proper on all architectures? I will have a =
look.
>> I think the solution is to have an arch dependent kvm_guest_exit(): em=
pty for
>> x86, clearing the bit for s390.
>=20
> I think we can merge your patches, as the userspace interface seems fin=
e. To=20
> make the accounting work for virtual cpu accounting found on ppc and s3=
90 we
> can later add an additional patch that also deals with interruptible gu=
est=20
> contexts.
> So something like this should work:
>=20
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>=20

It's fine for me.

Laurent
--=20
---------------- Laurent.Vivier@bull.net  -----------------
"Given enough eyeballs, all bugs are shallow" E. S. Raymond


--------------enig62AD99E413C702373828F710
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFHE30Y9Kffa9pFVzwRAmOnAKCfrMJqRwG+y+zndd52Z+7AO+4ygACgu2g9
bfKqW9wyh3tFoo5jgPHgWK0=
=AV/R
-----END PGP SIGNATURE-----

--------------enig62AD99E413C702373828F710--
