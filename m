Return-Path: <linux-kernel-owner+w=401wt.eu-S1765525AbXLPWas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765525AbXLPWas (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 17:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760964AbXLPWaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 17:30:24 -0500
Received: from os.eurotux.com ([216.75.63.6]:46811 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760780AbXLPWaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 17:30:22 -0500
Date: Sun, 16 Dec 2007 22:30:14 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Rafael Sisto <rafael.sisto@gmail.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: shared memory
Message-ID: <20071216223014.GA13628@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Rafael Sisto <rafael.sisto@gmail.com>,
	Linux kernel <linux-kernel@vger.kernel.org>
References: <ee3dc96c0712161151x7941e4e1y51a7631ada375c70@mail.gmail.com> <20071216195715.GA10287@bit.office.eurotux.com> <ee3dc96c0712161201y34a3e3e0t601ab4fa73d002c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <ee3dc96c0712161201y34a3e3e0t601ab4fa73d002c@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 16, 2007 at 05:01:17PM -0300, Rafael Sisto wrote:
> Thank you for the quick answer, but It's a college project, and I must
> share user level memory. I also must build my own system calls...
> But I can look what is already done and make something similar. Do you
> think shmget would do? Does it share user level memory?

Yes. They both do, but the Posix one is based on a ramfs or tmpfs on
/dev/shm and shared mmaps. I think analyzing the SysV version will be
better for your needs.

shmget: create the memory region
shmat: attach the memory region to this process.

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHZab1inSul6a7oB8RAho4AJ41lNoJ7o/0CPaEZSVLsGevjmfUUACeNgtu
H6yGlyFrHM75erbFFMtCFQc=
=I1eL
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
