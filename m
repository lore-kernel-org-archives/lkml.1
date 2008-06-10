Return-Path: <linux-kernel-owner+w=401wt.eu-S1758315AbYFJICe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbYFJICe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYFJICM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:02:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:54002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761AbYFJICK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:02:10 -0400
Subject: Re: Is configfs the right solution for configuration based fs?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Nizette <bn@niasdigital.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Joel Becker <joel.becker@oracle.com>,
       Satyam Sharma <ssatyam@cse.iitk.ac.in>, Felix Fietkau <nbd@openwrt.org>,
       Al Viro <viro@ftp.linux.org.uk>, "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <1213056772.4089.42.camel@moss.renham>
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 (sfid-20080608_232543_873639_74C0A387)  <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ke1UpQp2EOGtYEjtUp6b"
Date: Tue, 10 Jun 2008 10:01:20 +0200
Message-Id: <1213084880.22220.29.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ke1UpQp2EOGtYEjtUp6b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-10 at 10:12 +1000, Ben Nizette wrote:
> On Mon, 2008-06-09 at 11:03 +0200, Johannes Berg wrote:
>=20
> > Personally, I have a few issues with this:
> >  1) why bother with a second configuration interface that we have to
> >     maintain, adjust, ...? if we need scriptable access, then make a
> >     good userspace tool that is scriptable.
>=20
> What's the first one, sysfs..?  ioctl (eww..)? =20

netlink.

> >  2) string-based stuff is often messy, especially the varying attribute=
s
> >     like MAC addresses etc. Unless we just use binary files again, whic=
h
> >     is not very useful again. Take, for example, the monitor flags. If
> >     we use the same flags then nobody really knows what's up=20
> >     (echo 0x3 > mntr_flags?) and if we use strings then we cannot easil=
y
> >     ever rename the flag while keeping ABI/API compatibility.
>=20
> Not sure I see the argument here, why would you want to change the flag
> name?  If you decide the old name is stupid then can't you just alias
> the old name to the new one?

Sure can do, but it just adds a lot of complexity to the kernel. I don't
see the point, it's not like you need a lot of code to build netlink
messages. Heck, I've done it by _hand_ and used just netlink sockets.
It's not a lot of code.

> String handling is always a bit iffy, though it has to be done
> somewhere, either in kernel or in your "good userspace tool which is
> scriptable".  I'd prefer to have it done once, well, in the kernel and
> not have to ship more software than necessary.

I personally prefer to put it into userspace.

> >  3) afaik configfs doesn't actually support the mkdir, ... stuff yet
> >     that you want for virtual interfaces.
>=20
> It has all the  mkdir stuff I can think of, can you elaborate?  It
> doesn't have the commitable object support but I just have an 'enabled'
> attribute in there to switch the thing on and off.

I don't remember the specifics, it's been a while, I guess I could be
thinking of the commitable object support; mostly we'd want to configure
many things in one go, even on a live object. Without disabling that
object first, obviously.

johannes

--=-Ke1UpQp2EOGtYEjtUp6b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITjTMAAoJEKVg1VMiehFYvZoQAKcH5KQWV0TrvGmqQc1IXBcs
iAhp87sIECgk7/hj34dt5SrlpTl7TcxiKXrJerhGQT3pw6O0JDuFDsX1OvmyI5/j
dlAuKgA/4YQ7UcM9sS5L2MrC/EkxUZMBMIDBICZ6E9z9/Ee1F/SerAA/BsapU/T1
oek9gndO4d8fAtP+FoGXEMwn+9ZAomcD+JpL1azSKAhq2D++kjgpep1aEYQjgZqw
MR4ytNmUgT6dkhj1ohrSQRxUD8dj+qiZvXvdD+kSjbRJpyblZx/nDV623Eqs9iFV
SRy6xUw3RI9K6s3bygveBbQX+Wd+ym6cpFJsz0pZGSdpt2Q/z4BggsdBECG0ZVUG
eoxEXXjk+ryVO49ZrCt2pweQUXzI12L0QTp9yOqIM1elPHyjIR/sEO2kx91jVOXb
bHDhTnU2yAKR2pqWTXbBR/SaWbQvf2a1Oq6SORh8NfiiCfXCRSC4x6VepWZTw/xV
WyG2s4bw1SEamdzVdTtoupCeeCeCkFoC+QLqq9miYmQtTy/Gy/1EhE8A7XQWLlCJ
95Ppzx/ZePMmfH2UeK/mMw093vdAZqD1bVJGKrsNbB+7f5FkpkvEQAXFZ9HORGuk
unpGhqhVh+NWz/BOOIaSytZXu+Aya6TJoYRi6Ol83b5cR12NC8s7yIy+df5aMYax
6HBeUuzNeEZXVhkg4Fss
=iKtc
-----END PGP SIGNATURE-----

--=-Ke1UpQp2EOGtYEjtUp6b--

