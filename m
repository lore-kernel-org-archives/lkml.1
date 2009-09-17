Return-Path: <linux-kernel-owner+w=401wt.eu-S1759857AbZIQS7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857AbZIQS7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 14:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758619AbZIQS7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 14:59:36 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:49359 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759148AbZIQS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 14:59:35 -0400
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs
 maintenance disaster
From: Scott James Remnant <scott@canonical.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Kay Sievers <kay.sievers@vrfy.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
In-Reply-To: <20090917194725.355b761c@infradead.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	 <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
	 <20090917141303.428fe73c@lxorguk.ukuu.org.uk>
	 <1253205332.4718.9.camel@quest>  <20090917194725.355b761c@infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ccN/QQbpF5T3loNGeG33"
Date: Thu, 17 Sep 2009 19:59:16 +0100
Message-Id: <1253213956.4718.18.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ccN/QQbpF5T3loNGeG33
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-09-17 at 19:47 +0200, Arjan van de Ven wrote:

> > I don't really see the issue here.  If Arjan doesn't want to use
> > devtmpfs for Moblin, he doesn't have to.
>=20
> my biggest objection was to the use of boot time as argument.
> That was and still is deceiving and false. There may be other arguments
> for devfs, but I'm not going to get in the middle of those. But boot
> time isn't it.
>=20
Right, I don't disagree.

For some distributions devtmpfs allows them to do things without running
udev early; we long ago restructured Ubuntu so that udev is one of the
first things we run, therefore don't have that particular problem.

=46rom my POV devtmpfs is useful because it means we can do away with udev
entirely in certain situations, especially the installer and probably
our initramfs when we need one too.

The "statically make /dev from /sys" tools don't help, because /dev
needs to be kept up to date.  And udev is too heavy, or the increased
maintenance of having a special installer udev is too annoying, etc.

devtmpfs happens to be a neat solution to that problem.

> I do share frustration with Eric on how Kay and Greg have handled this.
> It really felt like a combination of bullying, ignoring any contrarian
> argument and just ramming stuff down. Not at all unlike the original
> devfs fiasco. It has left me with a pretty bad taste in my mouth and
> am pretty disappointed; I expected better.
>=20
I'm not a kernel developer, I'm a plumbing developer, but from my
outside perspective it seems like the contrary arguments have had a bit
of an agenda as well and have taken a "must not go in at any cost"
attitude.

That I find odd.

It's not as if this is critical path, or going in at the expense of
other functionality or code.  It's just another useful option for people
who can find a use for it.

Is that really such a tragedy to have?


Anyway, I should start packing and stuff.  See you next week!

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-ccN/QQbpF5T3loNGeG33
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqyhwQACgkQSnQiFMl4yK6eXgCfWQnKh/vRnt92nR2sD991PrgX
Fq0An0F0hSZyvROr6M2B5A8/46+oFRRX
=vkbR
-----END PGP SIGNATURE-----

--=-ccN/QQbpF5T3loNGeG33--

