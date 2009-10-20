Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZJTUcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZJTUcO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZJTUcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:32:14 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:42735 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbZJTUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:32:13 -0400
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
 (Was: Re: [PATCH] Remove broken by design and by implementation devtmpfs 
 maintenance disaster)
From: Scott James Remnant <scott@ubuntu.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <21d7e9970909201959j1268103fg9d88625072e089a@mail.gmail.com>
References: <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	 <alpine.LFD.2.01.0909180717380.4950@localhost.localdomain>
	 <20090918150541.GB9307@kroah.com>
	 <ac3eb2510909180837p195704e4y907e6f564acf6efd@mail.gmail.com>
	 <ac3eb2510909181235m33846928sa8c790758c66233@mail.gmail.com>
	 <20090918195005.GA11726@elte.hu>
	 <21d7e9970909191843l6fbb835bme509c18cedfd728c@mail.gmail.com>
	 <20090920150842.GF11621@kroah.com>
	 <ac3eb2510909200912o76e0d4e4l2dcaf352fe6b4e19@mail.gmail.com>
	 <ac3eb2510909200914g1ed6a47cydc0edec6fff96ef4@mail.gmail.com>
	 <21d7e9970909201959j1268103fg9d88625072e089a@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f6ZThZC110fWsGZZPbwj"
Date: Tue, 20 Oct 2009 21:32:05 +0100
Message-ID: <1256070725.2223.1.camel@warcraft>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f6ZThZC110fWsGZZPbwj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-21 at 12:59 +1000, Dave Airlie wrote:

> On Mon, Sep 21, 2009 at 2:14 AM, Kay Sievers <kay.sievers@vrfy.org> wrote=
:
> > Distros ship these matches for forever. It's a modprobe.conf blacklist =
entry
> > that's needed, or better disable thew floppy in the BIOS, if there isn'=
t one
> > to use.
> >
>=20
> The patch only went into the kernel last release or maybe one before,
> and it came from Ubuntu's kernel
>=20
This was the patch that fixed the missing MODALIAS strings for the PNP
subsystem, right?

(It also happened, at the same time, to fix the fact that the floppy
 module wasn't getting loaded for people who *had* floppy drives.)

The fact the floppy module takes 30s to give up and decide you don't
have a drive is very arguably a bug in the module.  And the fact your
boot waits for it is very arguably a bug in your boot ;)

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-f6ZThZC110fWsGZZPbwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkreHkUACgkQSnQiFMl4yK4VtACeIrO70NQyR+DO+sXZIdd0WgeQ
7i4An3JJD28cQVsUpZE+aX/w/Ijnf9wX
=nRd7
-----END PGP SIGNATURE-----

--=-f6ZThZC110fWsGZZPbwj--

