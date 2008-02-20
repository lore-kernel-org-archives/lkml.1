Return-Path: <linux-kernel-owner+w=401wt.eu-S1762355AbYBTOUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762355AbYBTOUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 09:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYBTOUj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 09:20:39 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3371 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbYBTOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 09:20:37 -0500
Message-ID: <47BC370F.3000705@imap.cc>
Date: Wed, 20 Feb 2008 15:19:59 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gregory Nietsky <gregory@networksentry.co.za>
CC: Sam Ravnborg <sam@ravnborg.org>, Andi Kleen <andi@firstfloor.org>,
       Greg KH <greg@kroah.com>, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za>
In-Reply-To: <47BAA072.9050601@networksentry.co.za>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig293FCE1DEB42272BB63C6917"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig293FCE1DEB42272BB63C6917
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Gregory Nietsky schrieb:
> ive been hackin away at mISDN for a while and use it with recent kernel=
s=20
>   2.6.2X and have a patch for 2.6.24 (move from semaphore to complition=
)=20
> the distro we built is heavily reliant on mISDN (voip) i dont use the=20
> isdn kernel drivers at all any longer.
>=20
> im all for mISDN been mainlined into the kernel and the old stuff been =

> removed there could be users still it is marked as depricated and the=20
> plan was with 2.6 to use mISDN from the start.

mISDN has two problems, which are of course interrelated:

a) complete lack of documentation for the in-kernel driver interface
    (equivalent of Documentation/isdn/INTERFACE)

b) still doesn't support all the hardware isdn4linux supports.

As long as those problems aren't solved, the old stuff cannot be removed.=

Perhaps merging the current state of mISDN into the -mm tree would help
with this. Perhaps not.

Regards,
Tilman
(maintainer of an isdn4linux driver, waiting desperately for
documentation on how to convert to the new CAPI/mISDN world
but tired of asking for it in vain)

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig293FCE1DEB42272BB63C6917
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvDcPQ3+did9BuFsRAk3bAJ93+SrUAZYc6ECscKzHnbP05w/SlwCggbaD
WqePBZrJbMC/23YP5xnQcus=
=z48m
-----END PGP SIGNATURE-----

--------------enig293FCE1DEB42272BB63C6917--
