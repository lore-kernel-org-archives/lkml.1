Return-Path: <linux-kernel-owner+w=401wt.eu-S932589AbXBKWeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589AbXBKWeT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932598AbXBKWeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:34:19 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40225 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932589AbXBKWeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:34:18 -0500
X-Sasl-enc: 08RZ72i3N+T90ujnREnPJ6w4LRcOTi3oO333NblD7Fq5 1171233255
Message-ID: <45CF9A22.2080102@imap.cc>
Date: Sun, 11 Feb 2007 23:35:14 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: lunz@falooley.org, olaf@aepfle.de, rol@witbe.net, akpm@osdl.org,
       linux-kernel@vger.kernel.org, rol@as2917.net
Subject: Re: [PATCH] keep track of network interface renaming
References: <20070211125423.GA30668@aepfle.de>	<20070211.095552.71093127.davem@davemloft.net>	<20070211182704.GA14021@avocado.homenet> <20070211.102852.45510952.davem@davemloft.net>
In-Reply-To: <20070211.102852.45510952.davem@davemloft.net>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig84B15C76C7287CC9F665A102"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig84B15C76C7287CC9F665A102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 11.02.2007 19:28 schrieb David Miller:
> From: Jason Lunz <lunz@falooley.org>
> Date: Sun, 11 Feb 2007 13:27:05 -0500
>=20
>> On Sun, Feb 11, 2007 at 09:55:52AM -0800, David Miller wrote:
>>> This is kernel log clutter.
>>>
>>> You can ask the kernel for the list of interfaces, and
>>> use even ethtool to ask what driver each interface is
>>> associated with.
>>>
>>> The patch wasn't applied because it really is not necessary.
>> I disagree completely. I'm working right now on a udev-based system th=
at
>> does ethernet device renaming. It's quite difficult when working with
>> udev to tell exactly when and why each interface was renamed, since it=
's
>> typically done within initramfs where it's difficult to enable debug
>> messages. This printk helps immensely.
>=20
> You can listen on a netlink socket for these events if you
> want to see when they occur.
>=20
> There is no need for this log message, it is superfluous.

I disagree. This message can be very helpful. The problem of network
interfaces being renamed is a real and frequent one. A single message
per interface is tolerable even if you don't actually need it. My
kernel log currently produces well over 400 messages per boot, so if
you want to reduce kernel log clutter, there are lots of other
candidates.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig84B15C76C7287CC9F665A102
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFz5oiMdB4Whm86/kRAotNAJ9jjVZ3Ov/B4t7XdMlg7Z/aypsfXACfcxp8
5oY/xJ9gmjdEPlw6phFLLXU=
=ydCk
-----END PGP SIGNATURE-----

--------------enig84B15C76C7287CC9F665A102--
