Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbYDNBCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbYDNBCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753376AbYDNBCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:02:10 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59149 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752918AbYDNBCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:02:09 -0400
X-Sasl-enc: b1uBeDCbN7ahbcNd2TIqbpD/a9O+OwZ7dDNi6hracxkT 1208134928
Message-ID: <4802AD0D.8040903@imap.cc>
Date: Mon, 14 Apr 2008 03:02:05 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Ray Lee <ray-lk@madrabbit.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Dave Airlie <airlied@gmail.com>,
       linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: [2.6.25-rc6] possible regression: X server dying
References: <47E82D68.5070305@imap.cc>	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>	 <47E83D14.8070800@imap.cc>	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com>	 <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>	 <47F1FA3F.3010206@imap.cc> <47FA9EC2.6030801@imap.cc> <2c0942db0804071555w2dc2e43fw7cce64d4a5ba004@mail.gmail.com>
In-Reply-To: <2c0942db0804071555w2dc2e43fw7cce64d4a5ba004@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6DB4BB433E44405182711116"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6DB4BB433E44405182711116
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 7, 2008 at 3:22 PM, Tilman Schmidt <tilman@imap.cc> wrote:
>> This is still quite elusive. It only happens once every couple of days=
,
>>  and the only thing that seems to be clear is that it's triggered by a=
 GL
>>  screensaver.

Ok, I think I can now reproduce it, and it does not, in fact, appear
to be kernel related. Specifically, doing:

% /usr/lib/xscreensaver/antspotlight & /usr/lib/xscreensaver/atlantis

in a console window (ie. running *two* GL screensavers in parallel)
reliably kills my X server on kernels 2.6.22.17, 2.6.24.4 and 2.6.25-rc9,=

with a backtrace much like the ones I posted. So it seems to be an X serv=
er
problem that I just happened to encounter for the first time while trying=

out 2.6.25-rc6.

Thanks,
Tilman



--------------enig6DB4BB433E44405182711116
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIAq0NMdB4Whm86/kRAgDHAJsFTxTOXkD2td8+0OlkxdCL+pgVtACffB9d
Zpgb5dFi1LyoLgRnEbOuU2c=
=tq7O
-----END PGP SIGNATURE-----

--------------enig6DB4BB433E44405182711116--
