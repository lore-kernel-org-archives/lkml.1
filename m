Return-Path: <linux-kernel-owner+w=401wt.eu-S1755538AbYBYOkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538AbYBYOkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 09:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754314AbYBYOkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 09:40:08 -0500
Received: from mail.phnxsoft.com ([195.227.45.4]:3362 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbYBYOkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 09:40:06 -0500
Message-ID: <47C2D312.60100@imap.cc>
Date: Mon, 25 Feb 2008 15:39:14 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: kkeil@suse.de
CC: Simon Richter <sjr@debian.org>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <greg@kroah.com>, Gregory Nietsky <gregory@networksentry.co.za>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       isdn4linux@listserv.isdn4linux.de, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Plans for mISDN?
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org> <20080218045209.GA15141@kroah.com> <p73zltyxy9q.fsf@bingen.suse.de> <20080219085033.GA1775@uranus.ravnborg.org> <47BAA072.9050601@networksentry.co.za> <47BC370F.3000705@imap.cc> <47BD5360.5070706@debian.org> <20080222120412.GA11916@pingi.kke.suse.de>
In-Reply-To: <20080222120412.GA11916@pingi.kke.suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE8C596D91BA0E0A400628E03"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE8C596D91BA0E0A400628E03
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 22.02.2008 13:04, Karsten Keil wrote:
> These design issues are fixed in the new mISDN socket branch.
> The old mISDN design was too complicated because it allow access to
> every layer and build the ISDN stack dynamically, both feature were nev=
er
> needed in practice and contain many race conditions.
> The new design only has one core module and hardware specific modules
> with a very simple interface.

Great news. I pulled your socket branch and am currently trying to
find my way through one of the two hardware drivers available there
and abstract away from the PCI card specific parts.
Is there a design document available? Or will there be some non-PCI
driver soon, perhaps even one for a USB device? That would be
immensely helpful.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigE8C596D91BA0E0A400628E03
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHwtMTQ3+did9BuFsRAiQIAJ4nag1zqgpKKKS4na+Pjyq1G4MsgQCffdf3
Qxie5tSIWEFGUGifmhCD1X0=
=JgiE
-----END PGP SIGNATURE-----

--------------enigE8C596D91BA0E0A400628E03--
