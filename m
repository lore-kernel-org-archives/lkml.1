Return-Path: <linux-kernel-owner+w=401wt.eu-S936450AbYBVAx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936450AbYBVAx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756961AbYBVAxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:53:00 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52381 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756789AbYBVAw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:52:58 -0500
X-Sasl-enc: SvK5a1Mg8urY7vxp1K8HMcfuevggmEZjgs248GxUkL65 1203641576
Message-ID: <47BE1CE5.1030001@imap.cc>
Date: Fri, 22 Feb 2008 01:52:53 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: 2.6.25-rc2-mm1 - several bugs and a crash
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47BC982C.7050402@imap.cc> <47BD6072.4000407@trash.net> <47BE1A03.30300@imap.cc>
In-Reply-To: <47BE1A03.30300@imap.cc>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCCD2F034FE8C131B9A0DD061"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCCD2F034FE8C131B9A0DD061
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 22.02.2008 01:40 schrieb Tilman Schmidt:
>>
>>     [NETFILTER]: nf_conntrack: fix smp_processor_id() in preemptible c=
ode warning
>=20
> Yes, it does; and the system also survives substantially longer.
> (IOW, it hasn't crashed on me so far.)

Which of course it did the second after I sent off that mail. :-(
No message at all this time at the time of the crash, even though
I had "tail -f /var/log/messages" running in an ssh session.

So the nf_conntrack BUG is fixed, but the crash (and of course the
swapper "spinlock bad magic" BUG) persists.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCCD2F034FE8C131B9A0DD061
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHvhzmMdB4Whm86/kRAuBrAJ9l0FIXZ9jvWnVoxMJyliSMUoOs9gCfd7io
AsVKB8OH/pIgpWucpICt9hw=
=UIri
-----END PGP SIGNATURE-----

--------------enigCCD2F034FE8C131B9A0DD061--
