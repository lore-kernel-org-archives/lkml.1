Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbZGIKyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbZGIKyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 06:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754886AbZGIKyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 06:54:15 -0400
Received: from mail.open.by ([193.232.92.17]:62536 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039AbZGIKyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 06:54:14 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 8979 [Jul 09 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Thu, 9 Jul 2009 13:55:49 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: kmemeleak BUG: lock held when returning to user space!
Message-ID: <20090709105549.GB3434@localdomain.by>
References: <20090709104202.GA3434@localdomain.by>
 <tnxeisquo90.fsf@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <tnxeisquo90.fsf@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/09/09 11:47), Catalin Marinas wrote:
> Date: Thu, 09 Jul 2009 11:47:23 +0100
> From: Catalin Marinas <catalin.marinas@arm.com>
> To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
> 	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
> 	linux-kernel@vger.kernel.org, linux-mm@kvack.org
> Subject: Re: kmemeleak BUG: lock held when returning to user space!
> User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
>=20
> Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:
> > kernel: [  149.507103] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > kernel: [  149.507113] [ BUG: lock held when returning to user space! ]
> > kernel: [  149.507119] ------------------------------------------------
> > kernel: [  149.507127] cat/3279 is leaving the kernel with locks still =
held!
> > kernel: [  149.507135] 1 lock held by cat/3279:
> > kernel: [  149.507141]  #0:  (scan_mutex){+.+.+.}, at: [<c110707c>] kme=
mleak_open+0x4c/0x80
> >
> > problem is here:
> > static int kmemleak_open(struct inode *inode, struct file *file)
>=20
> It's been fixed in my kmemleak branch which I'll push to Linus:
>=20
Ok. Nice to hear.

> http://www.linux-arm.org/git?p=3Dlinux-2.6.git;a=3Dshortlog;h=3Dkmemleak
>=20
> --=20
> Catalin
>=20

	Sergey
--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpVzLUACgkQfKHnntdSXjTpQwQA1EX6uQ7i38G8BWSaWAOzltDW
G7Kat5fxYMQGt8/fswOF0ODBEa6a8fm2ThIWkIRpUIN/MFDE7j3OMAfw8pfvwpDt
p55fvdbG82nR4Nw4MW7JIsldTRF0/s2Vf9+8HJ921IiBoFgh3yexpHC8UBAqYZ6f
mRzNxn2itpIxsCDSZBk=
=2xyK
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
