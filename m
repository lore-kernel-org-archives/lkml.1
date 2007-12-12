Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbXLLPaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbXLLPaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbXLLPaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:30:04 -0500
Received: from os.eurotux.com ([216.75.63.6]:47108 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752147AbXLLPaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:30:01 -0500
Date: Wed, 12 Dec 2007 15:29:55 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: ldm@flatcap.org, ntfs-3g-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: Re: ldminfo compilation
Message-ID: <20071212152953.GA26544@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	Alon Bar-Lev <alon.barlev@gmail.com>, ldm@flatcap.org,
	ntfs-3g-devel@lists.sourceforge.net,
	LKML <linux-kernel@vger.kernel.org>,
	linux-ntfs-dev@lists.sourceforge.net
References: <9e0cf0bf0712120639r7bd5582bg63f8512164836989@mail.gmail.com> <20071212145241.GA25092@bit.office.eurotux.com> <9e0cf0bf0712120657p1a8fac7aoc5a82df1ff24daac@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <9e0cf0bf0712120657p1a8fac7aoc5a82df1ff24daac@mail.gmail.com>
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 12, 2007 at 04:57:39PM +0200, Alon Bar-Lev wrote:
> On 12/12/07, Luciano Rocha <luciano@eurotux.com> wrote:
> > Those are for the kernel module setting the partition tables. If you're
> > only interested in the ldminfo utility:
> > make -C ldmutil CPP=3D'g++ -static'
> >
> > Substitute g++ for the C++ compiler you want to use.
>=20
> Hi!
> Thank you for your reply!
>=20
> I don't really understand how to use the output of ldmutil in order to
> do the dmsetup... All the instructions are for ldminfo...

Ah, sorry. Somehow I got the impression that the ldmutil directory
included the ldminfo binary. I'll see if I can compile the ldminfo
statically in an older system I have.

>=20
> And the C++ dependency does not work well with uclibc... I tried to
> compile this using uclibc++, but the exception handling of uclibc++ is
> broken for some strange reason... And I don't wish to introduce the
> overhead of the C++ libraries to my system...
>=20
> If ldmutil contain all the information, I will backport this to C and
> be happy... :)
> Can you please tell me how you use the output of this utility to merge
> a spanned partition on two separate disks?

I don't have a Windows dynamic disk, so I can't imagine out to convert
the output for dmsetup. Do you have a sample output?

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHX/5xinSul6a7oB8RAsoHAJ4hW1uCixg0FtDTlTY1B2D41+Iq8ACeNSbT
CJYzH/Y2AopqKoc9uPHMKXs=
=eHQN
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
