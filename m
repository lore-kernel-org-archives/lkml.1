Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbYEZXRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbYEZXRh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 19:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbYEZXR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 19:17:28 -0400
Received: from mail.vapor.com ([85.114.133.49]:51226 "EHLO mail.vapor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbYEZXR1 (ORCPT <rfc822;Linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 19:17:27 -0400
X-Greylist: delayed 1259 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 May 2008 19:17:27 EDT
Subject: [ipv6] Odd behaviour...
From: Ian Kumlien <pomac@vapor.com>
Reply-To: pomac@vapor.com
To: Linux-kernel <Linux-kernel@vger.kernel.org>
Cc: linux-net <Linux-net@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3OLGDm+tt2/bsqDp0FsK"
Date: Tue, 27 May 2008 00:58:30 +0200
Message-Id: <1211842711.8367.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3OLGDm+tt2/bsqDp0FsK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,=20

I just recently acquired a new ipv6 tunnel since my two previous brokers
has gone out of business. I now use hurricane electrics tunnel since i
have really good ping times to it's node in Amsterdam.

Anyways, i have setup a local network tunnel and enabled forwarding.

After about 300 seconds, it all stops working. I have to disable and
re-enable it on the firewall/router to get it working again.

tcpdump shows the router/firewall doing odd things like:
(i renamed my host to piv6)

00:48:14.294173 IP6 piv6 > igloo.stacken.kth.se: ICMP6, echo request,
seq 321, length 64

00:48:14.341288 IP6 igloo.stacken.kth.se > piv6: ICMP6, echo reply, seq
321, length 64

00:48:14.341317 IP6 fe80::55e4:1b90 > igloo.stacken.kth.se: ICMP6,
redirect, piv6 to piv6, length 160

00:48:14.341332 IP6 igloo.stacken.kth.se > piv6: ICMP6, echo reply, seq
321, length 64
---

fe80::55e4::1b90 is the local ip of the ipv6 tunnel.
(note: the packet never arrives at it's destination)

Any ideas of what could be going wrong?		=09

--=20
Ian Kumlien <pomac () vapor ! com> -- http://pomac.netswarm.net

--=-3OLGDm+tt2/bsqDp0FsK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkg7QJYACgkQ7F3Euyc51N+eDACgnfltSulml4XgANq8De6ve8tZ
G78An0buWnzh4yPan4SwknAfHI1GvR9Q
=RxHd
-----END PGP SIGNATURE-----

--=-3OLGDm+tt2/bsqDp0FsK--

