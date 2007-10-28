Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbXJ1SvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbXJ1SvB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbXJ1Suw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:50:52 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37605 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbXJ1Suv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:50:51 -0400
X-Sasl-enc: V7+d2RZtd2HaM0oekh4UGT0wYGEVEcC6wWRHEkb/8FOg 1193597449
Message-ID: <4724DA20.1010609@imap.cc>
Date: Sun, 28 Oct 2007 19:51:12 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Greg KH <greg@kroah.com>, Simon Arlott <simon@fire.lp0.eu>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, James Morris <jmorris@namei.org>,
       Crispin Cowan <crispin@crispincowan.com>,
       Giacomo Catenazzi <cate@debian.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: eradicating out of tree modules
References: <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de>
In-Reply-To: <20071028005555.GC23339@stusta.de>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1E7B146A77D51A5ECE7972C6"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1E7B146A77D51A5ECE7972C6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 28.10.2007 02:55 schrieb Adrian Bunk:
> Justifying anything with code with not GPL compatible licences has zero=
=20
> relevance here.
>=20
> And there's value in making life harder for such modules with=20
> questionable legality. As an example, consider people who experienced=20
> crashes of "the Linux kernel" caused by some binary-only driver.
> Not that uncommon e.g. with some graphics drivers.
> This harms the reputation of Linux as being stable.

You are mixing up several distinct categories here: "out of tree"
!=3D "non-GPL" !=3D "proprietary" !=3D "of questionable legality" !=3D
"binary-only" !=3D "causing kernel crashes".

> The solution is not to support proprietary drivers, the solution is to =

> get open source replacements.

So how do you propose to "get" those replacements? And what shall
users do during the time this "getting" may take?

> If it's low quality code doing something useful - well, how many hundre=
d=20
> people are on Greg's list only waiting for some driver they could write=
?

No idea. Obviously not enough to actually solve the problem.
What solution do you propose?

>> [D]o you think the world would
>> be a better place if all the existing out-of-tree modules
>> just ceased to exist, without any replacement?
>=20
> With your "without any replacement" you needlessly excluded the=20
> reasonable solution:
>=20
> The solution is that someone other than the author either takes the=20
> existing external code or rewrites it from scratch, submits it for=20
> inclusion into the kernel, and maintains it there.

My "without any replacement" is just a description of reality.
All current external code I am aware of continues to exist only
because there is no in-kernel replacement.

Again: how do you propose to bring that solution of yours to pass,
how long do you think it will take, and what do you propose current
users of out-of-tree modules do in the meantime?

Without reasonable answers to these questions, your proposed
solution itself hardly qualifies as reasonable.

> Let me repeat that Greg has said he has hundreds of volunteers for such=
=20
> tasks.

Even with hundreds of volunteers, your proposed solution of just
rewriting *all* external code in a way fit for inclusion into the
kernel is an unachievable goal. Just look at the list on
http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
and try to answer why each of them is still out of tree.
Hint: In most cases it's neither out of malice nor stupidity on
the authors' part.

Of course in-tree code is always better than out-of-tree code. But
I maintain there will always be out-of-tree code (modules, drivers,
whatever) that fills a real need not (though hopefully, just not
yet) satisfied by any in-tree code. All I'm asking for is that you
take a pragmatic stance with regard to that: not going to any great
lengths to support it, but acknowledging its existence and
legitimacy - and not inciting to deliberately break it.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig1E7B146A77D51A5ECE7972C6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHJNogMdB4Whm86/kRAsPPAJ489uVCUEKpWxpnsWuUO4mmV/WNigCfaUwF
gU64Hl/nrSVrbH4bQIPLtaE=
=nkDD
-----END PGP SIGNATURE-----

--------------enig1E7B146A77D51A5ECE7972C6--
