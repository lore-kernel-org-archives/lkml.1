Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYEVTGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYEVTGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 15:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEVTGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 15:06:05 -0400
Received: from gozo.interway.ch ([194.246.118.4]:59143 "EHLO gozo.interway.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659AbYEVTGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 15:06:04 -0400
Message-ID: <4835C40B.60603@interway.ch>
Date: Thu, 22 May 2008 21:05:47 +0200
From: Matthias Cramer <matthias.cramer@interway.ch>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: James Chapman <jchapman@katalix.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: Wired behaviour with IPv6 over PPP
References: <48341C0B.7010003@interway.ch> <20080522014959.0f6191aa.akpm@linux-foundation.org> <48354318.60202@katalix.com>
In-Reply-To: <48354318.60202@katalix.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2D9BF51E945CBAD54BE20CB5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2D9BF51E945CBAD54BE20CB5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

James Chapman wrote:
> Andrew Morton wrote:
>> On Wed, 21 May 2008 14:56:43 +0200 Matthias Cramer
>> <matthias.cramer@interway.ch> wrote:
>>> I have a very wired behaviour when doing IPv6 over PPPoE.
>>>
>>> The situation:
>>>
>>> A linux box connected to a DSL Modem, on the other side is a Cisco
>>> LNS which terminates the PPP session (actually L2TP).
>>> I have control over both ends.
>>>
>>> When I have net.ipv6.conf.all.forwarding set to 0 then the ppp
>>> Interface gets a IPv6 address from the Cisco via IP6CP.
>>> When I have net.ipv6.conf.all.forwarding set to 1 them the ppp
>>> Interface does not get an address, it has only a normal link local
>>> address.
>=20
> What do you mean by normal link local address?

a fe80:: address, which every IPv6 enabled Interface has...

>=20
>>> When I start the ppp session with forwarding set to 0 I can ping out
>>> and there exists a default route to ppp0 , then I switch forwarding t=
o 1
>>> the default route disappears and therefore routing does not work any
>>> longer.
>=20
> Did this work with previous kernel versions?

No, in my opinion it never worked. But I thought that pppd does it wrong
because id never got an IPv6 address. But I had always forwarding
enabled. Now in this case i started pppd without forwarding enabled and
got an address.

>=20
> Does pppd log any errors?

No, no errors

--=20
Matthias Cramer                System & Network Manager
Interway Communication GmbH    Phone +41 43 500 1111
Josefstrasse 225               Fax   +41 44 271 3535
CH-8005 Zuerich                http://www.interway.ch/


--------------enig2D9BF51E945CBAD54BE20CB5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Public key at: http://www.freestone.net/~cramer/cramer.pgp.php
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFINcQTti/fHC0gglARAvWPAJ0ZHNBeGx7iB7YtV214/vqhf8alcACbB5Jd
DUxuFImnGZCPTPysJ74RtUQ=
=1m1s
-----END PGP SIGNATURE-----

--------------enig2D9BF51E945CBAD54BE20CB5--
