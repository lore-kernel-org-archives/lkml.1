Return-Path: <linux-kernel-owner+w=401wt.eu-S1753235AbZAMP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbZAMP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 10:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZAMP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 10:57:48 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:54245 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbZAMP5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 10:57:46 -0500
X-RZG-CLASS-ID: mo00
X-RZG-AUTH: :IWUQZkOgW+3CqJDygERk+CxWRHhOt44/ODBTDQK7pLSymoIa1YEVchgk7u1gmgw=
Subject: Re: "Artem Onair Comcard 11": Variation found!
From: Michael Jarosch <mitsch@riotmusic.de>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1229506383.8040.2.camel@cat>
References: <1228304996.8921.93.camel@cat>
	 <20081205113001.GA1452@ports.donpac.ru>  <1229506383.8040.2.camel@cat>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8+9NlCmj39avzg5SXvJd"
Organization: Riot-Music
Date: Tue, 13 Jan 2009 16:57:40 +0100
Message-Id: <1231862260.10639.281.camel@cat>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8+9NlCmj39avzg5SXvJd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi there!

A month has passed and so I'm writing you the latest news...

First a summary:

1) Bought an "Artem Onair Comcard 11". Label on the back says:
"CC-W11-EMB" "PC-ETS-128"
"2,4 GHz 11 Mb/s DSSS WEP 128"

2) Plug the card to three laptops.
	Laptop #1: Toshiba Satellite Pro 4820/Debian Lenny/Kernel 2.6.26
	Laptop #2: IBM Thinkpad A21p/Debian Lenny/Kernel 2.6.26
	Laptop #3: Toshiba Satellite 1110/Ubuntu 8.10/Kernel 2.6.27
no reaction on all laptops.

3) Found out, that there's no matching modalias for this card in no
module.

4) Found out, that the module for this card should be "orinoco_cs".

5) Asked Pavel Roskin to add the missing modalias. He sent a patch to
kernel.org. It's not included, yet.

6) With a little trick (echo a modalias to .../orinoco_cs/new_id) I can
use the driver with this card.



O.k., this was a brief summary. Now to my problem: On all laptops, it is
not possible to change the channel with iwconfig. I'm stuck to channel
3. Error message is:


Error for wireless request "Set Frequency" (8B04) :
	SET failed on device eth1: Device or ressource busy.


(It's also not possible to use wpa_supplicant. At least I didn't find
the right driver and I read in
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/66696 that there
isn't any. But I guess this is not a kernel issue.)

Conclusion: The driver itself works, scanning works and that means that
the driver is sending and receiving packages. But it's not possible to
change the channel and to use wpa_supplicant and therefore it's really
hard to connect to an AP.

I'm still ready to support you! ;)

Mitsch

--=-8+9NlCmj39avzg5SXvJd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklsufQACgkQNFzJVOwishkkIACg7SrAlZ1TiCzeIgKTe80lDLR/
BVkAoM9USZMDZo4g8Thx90ydYWN7X1zz
=ePqo
-----END PGP SIGNATURE-----

--=-8+9NlCmj39avzg5SXvJd--

