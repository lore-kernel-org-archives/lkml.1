Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760045AbYLQJda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760045AbYLQJda (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 04:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759151AbYLQJdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 04:33:12 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:22901 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYLQJdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 04:33:10 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :IWUQZkOgW+3CqJDygERk+CxWRHhOt44/ODBTDQK7pLSymoIa1YEVchAt9fQP
Subject: Re: "Artem Onair Comcard 11": Variation found!
From: Michael Jarosch <mitsch@riotmusic.de>
To: linux-kernel@vger.kernel.org
In-Reply-To: <20081205113001.GA1452@ports.donpac.ru>
References: <1228304996.8921.93.camel@cat>
	 <20081205113001.GA1452@ports.donpac.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VCELRedI38vqAFPr60xY"
Organization: Riot-Music
Date: Wed, 17 Dec 2008 10:33:03 +0100
Message-Id: <1229506383.8040.2.camel@cat>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VCELRedI38vqAFPr60xY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Freitag, den 05.12.2008, 14:30 +0300 schrieb Andrey Panin:
> On 338, 12 03, 2008 at 12:49:55PM +0100, Michael Jarosch wrote:

> > I recently bought a WLAN-PCMCIA-adaptor from Ebay, named "ARtem
Onair
> > Comcard 11", which is reported to work with linux on several places
in
> > the internet. Well - my special card doesn't work. [...] I did
> > some investigation about this card, which I want to tell you, and I
hope
> > that this will help someone of the kernel-team to get things right!
>=20
> Can you try to load orinoco_cs driver by hand and then add PCMCIA id
of
> your card using command below ?
>=20
> echo "0x3 0x0268 0x0003 0 0 0 0 0 0 0"
>/sys/bus/pcmcia/drivers/orinoco_cs/new_id

It works (partly)!
I got an ethernet device with ifconfig, called ethX. And I can do some
scanning with iwlist!

What I can't do is: switching to another channel (with "iwconfig eth0
channel 9" f.e.) - my device is always on channel 3, but the only AP I
could connect to is channel 9. So - still - I can't proof that the
card's now able to build a wireless connection  with that driver. But
I'll keep going! Today, I've only got LXDE installed, but the next days
I'll try out gnome and it's network-manager and keep you up to date.

This is the output of "iwlist eth0 event":
eth0    Wireless Events supported :
        0x8B04 : Set Frequency/Channel (kernel generated)
        0x8B06 : Set Mode (kernel generated)
        0x8B13 : Spy threshold crossed
        0x8B15 : New Access Point/Cell address - roaming
        0x8B19 : Scan request completed
        0x8B1A  : Set ESSID (kernel generated)
        0x8B2A : Set Encoding (kernel generated)
        0xBC00 : Tx packet dropped - retry exceeded


I also tried the "echo ..." command you sent me with the wavelan_cs
driver - it gave me an ethernet device but I couldn't do nothing with
it: So, one thing is clear: The tuxmobil.org entry is wrong. orinoco_cs
is the right driver! (At least, it is better than the wavelan_cs
driver...)

Greetings and many thanks!
Mitsch


--=-VCELRedI38vqAFPr60xY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklIx08ACgkQNFzJVOwishmbNwCfVkz1mLl2nWHjvGEAidZMBN6O
VqMAn2aBHshQYBho0fj5aoCVpfXEsUxz
=7B9c
-----END PGP SIGNATURE-----

--=-VCELRedI38vqAFPr60xY--

