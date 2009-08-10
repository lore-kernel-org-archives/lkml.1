Return-Path: <linux-kernel-owner+w=401wt.eu-S1752932AbZHJJEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbZHJJEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbZHJJEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:04:12 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:58805 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZHJJEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:04:11 -0400
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
From: Scott James Remnant <scott@ubuntu.com>
To: David Dillow <dave@thedillows.org>
Cc: Andi Kleen <andi@firstfloor.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>
In-Reply-To: <1249575658.19886.8.camel@lap75545.ornl.gov>
References: <20090805171513.GA10443@kroah.com>
	 <20090805192037.19c54c4d@lxorguk.ukuu.org.uk>
	 <20090805182805.GA7534@kroah.com> <20090805185136.GA21442@kroah.com>
	 <87ljlxhrnr.fsf@basil.nowhere.org>
	 <1249575658.19886.8.camel@lap75545.ornl.gov>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/RHolh+003P+GFPCubj9"
Date: Mon, 10 Aug 2009 10:04:09 +0100
Message-Id: <1249895049.4431.7.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/RHolh+003P+GFPCubj9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 12:20 -0400, David Dillow wrote:

> On Thu, 2009-08-06 at 17:46 +0200, Andi Kleen wrote:
> > Greg KH <greg@kroah.com> writes:
> > >
> > > It makes the userspace boot process much simpler and easier to mainta=
in,
> > > as well as providing a way to handle rescue disks and images triviall=
y,
> > > and it makes the kernel _less_ dependant on the early userspace bootu=
p
> > > scripts.
> >=20
> > As a initrd less kernel user I can really only agree: getting rid
> > of the udev-in-initrd requirement would be a big step forward
> > in usability. Typically I always have to pre populate=20
> > a on disk /dev manually first to get my kernels to boot.
>=20
> If you use mount by label or UUID, you still need udev (or other tools)
> in the initrd to find the right disk, correct? And for distros that want
> to support that, does this really reduce the amount of code in the
> initrd?
>=20
Distros would be then free to experiment with just running "blkid" in
the initramfs to find the root filesystem, rather than the udev daemon
(which runs blkid itself)

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-/RHolh+003P+GFPCubj9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkp/4okACgkQSnQiFMl4yK6/HgCgmEhkkKv/YqwefnWsEH8CX/FC
UNUAoIZ8V2JZ9qI3y1XV++p/GrVZuqEg
=wBPl
-----END PGP SIGNATURE-----

--=-/RHolh+003P+GFPCubj9--

