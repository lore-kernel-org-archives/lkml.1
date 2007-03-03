Return-Path: <linux-kernel-owner+w=401wt.eu-S1030524AbXCCWrh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030524AbXCCWrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 17:47:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXCCWrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 17:47:37 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:33644 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030524AbXCCWrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 17:47:36 -0500
X-Sasl-enc: U7eeX0mMPNEmH0YoxIiOq3onOnglxyhCjXb/Ng4wu2nR 1172962055
Message-ID: <45E9FB54.4030905@imap.cc>
Date: Sat, 03 Mar 2007 23:48:52 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Suspend/resume semantics for ISDN drivers (was: NAK new drivers without
 proper power management?)
References: <1171058269.1484.64.camel@nigel.suspend2.net>	 <1171059433.8675.195.camel@laptopd505.fenrus.org>	 <20070210193851.GA3956@ucw.cz>  <200702102320.39531.rjw@sisk.pl>	 <1171147026.19894.16.camel@nigel.suspend2.net>  <45CE5934.3020801@imap.cc> <1171233454.4493.74.camel@nigel.suspend2.net> <45CFB06B.5080102@imap.cc>
In-Reply-To: <45CFB06B.5080102@imap.cc>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFC7ADB186EBAA27297DAAC52"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFC7ADB186EBAA27297DAAC52
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Ok, I've thought some more but I still don't know ...

On 12.02.2007 01:10 I wrote:
> I don't doubt your basic assessment. However it doesn't translate that
> easily into a real implementation. In my case, I maintain a USB driver,=

> so I have to deal with USB specifics of suspend/resume which happen not=

> to be that well documented. My driver provides an isdn4linux device but=

> isdn4linux knows nothing about suspend/resume so I am on my own on how
> to reconcile the two. The device itself, though in turn far from trivia=
l,
> is actually the least of my worries.

So, how *should* an isdn4linux driver handle a request to suspend?
Specifically, if there are active connections, should it try to
shut them down in an orderly fashion (which might imply some delays
waiting for the remote station to acknowledge, etc.)? Should it kill
them abruptly (as for a USB unplug event)? Or should it just refuse
to suspend while a connection is still active?

Thanks for any insights,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigFC7ADB186EBAA27297DAAC52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF6ftbMdB4Whm86/kRAt8rAJ4xowx3r0mTWiXELn8Z1ITJiGOlfQCfVlV7
4O57fTpjErAC2Lm3PmSQ4Es=
=Z6yZ
-----END PGP SIGNATURE-----

--------------enigFC7ADB186EBAA27297DAAC52--
