Return-Path: <linux-kernel-owner+w=401wt.eu-S1763062AbXHYF6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763062AbXHYF6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 01:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757418AbXHYF6W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 01:58:22 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:46611 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbXHYF6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 01:58:22 -0400
X-Greylist: delayed 2036 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Aug 2007 01:58:22 EDT
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
From: Matt Colyer <matt@colyer.name>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
       linux-kernel@vger.kernel.org, jeffm@suse.de,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <Pine.LNX.4.44L0.0708241449520.22079-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0708241449520.22079-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fjDuVDp9dwNxKV1Oxt6b"
Date: Fri, 24 Aug 2007 19:21:55 -0700
Message-Id: <1188008516.14761.7.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fjDuVDp9dwNxKV1Oxt6b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 14:55 -0400, Alan Stern wrote:
> On Fri, 24 Aug 2007, Greg KH wrote:
>=20
> > Can someone with a iphone test this out?  If you look at how the
> > berry_charge driver does it, the set_config stuff happens after the
> > magic command.  As I don't have an iphone, nor have I ever seen any
> > dumps of the command streams, I don't really know if the set_config
> > message really is necessary or not.
>=20
> You know, now that I think back on it, it may be that the Set-Config
> really does have to come after the magic command.  Perhaps it triggers
> the changeover.  In which case the subroutine should look like this:
>=20
Hi all,
 I was the one who wrote the patch initially (sorry I haven't been able
to chime in sooner). It turns out that the configuration must be set
after the magic command (I tried both versions of the code tonight and
only the one which changes the configuration after the command works).
That said, I am not opposed to using a userspace program to accomplish
this task (I tried to pursue that avenue at first and couldn't find a
way to do, probably because it doesn't exist yet). I don't really have
much experience in this area, so I am not really sure how to proceed.

However the other part of this puzzle is that when you call lsusb the
iPhone disconnects from the bus. Greg suggested that it might be an
issue with the USB_SUSPEND support being broken on the iPhone and he
suggested I tried adding it to the quirks.c file. I'll be sure to let
you guys know when I figure it out.

-Matt

--=-fjDuVDp9dwNxKV1Oxt6b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGz5JDbkQaRhQ29KURAi9kAKC21UKdSV5HgpMTtIYWmPNN3mevAgCgq8dI
Zp59+fJVY/FW+oatSU6tiOs=
=OSL6
-----END PGP SIGNATURE-----

--=-fjDuVDp9dwNxKV1Oxt6b--

