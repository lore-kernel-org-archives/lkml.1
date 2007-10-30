Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbXJ3A3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbXJ3A3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 20:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbXJ3A3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 20:29:06 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:44790 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752681AbXJ3A3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 20:29:04 -0400
X-Sasl-enc: hgNxMu4sdaxx1isXH6MKhKviBar2klvda8ywB5TgEvlP 1193704141
Message-ID: <47267ADD.2030202@imap.cc>
Date: Tue, 30 Oct 2007 01:29:17 +0100
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
References: <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com> <4721B77F.8070102@imap.cc> <20071026232653.GF30533@stusta.de> <47234F73.3040809@imap.cc> <20071028005555.GC23339@stusta.de> <4724DA20.1010609@imap.cc> <20071028192528.GF7227@stusta.de>
In-Reply-To: <20071028192528.GF7227@stusta.de>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB8E4E9B08C5222BB816C220E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB8E4E9B08C5222BB816C220E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 28.10.2007 20:25 schrieb Adrian Bunk:
> On Sun, Oct 28, 2007 at 07:51:12PM +0100, Tilman Schmidt wrote:
>> Am 28.10.2007 02:55 schrieb Adrian Bunk:
>>> Justifying anything with code with not GPL compatible licences has ze=
ro=20
>>> relevance here.
>>>
>>> And there's value in making life harder for such modules with=20
>>> questionable legality. As an example, consider people who experienced=
=20
>>> crashes of "the Linux kernel" caused by some binary-only driver.
>>> Not that uncommon e.g. with some graphics drivers.
>>> This harms the reputation of Linux as being stable.
>> You are mixing up several distinct categories here: "out of tree"
>> !=3D "non-GPL" !=3D "proprietary" !=3D "of questionable legality" !=3D=

>> "binary-only" !=3D "causing kernel crashes".
>=20
> "binary-only non-GPL out-of-tree module causes kernel crashes" is a=20
> quite common pattern for some popular binary-only modules.

Common, yes. Popular, maybe. The only one, not. Taking that as reason
for breaking out-of-tree open source modules is throwing out the baby
with the bathwater.

>>> The solution is not to support proprietary drivers, the solution is t=
o=20
>>> get open source replacements.
>> So how do you propose to "get" those replacements? And what shall
>> users do during the time this "getting" may take?
>=20
> They should swamp the hardware vendors with requests for releasing=20
> hardware specifications.

They are doing that already. But somehow it fails to magically cause
open source drivers to spring into existence immediately. The crucial
word here is *time*.

> Or even better buy their hardware from a competitor.

Hmmm. "Your existing hardware isn't supported anymore, buy new one?"
I thought that was a Microsoft line. (SCNR)

>>> If it's low quality code doing something useful - well, how many hund=
red=20
>>> people are on Greg's list only waiting for some driver they could wri=
te?
>> No idea. Obviously not enough to actually solve the problem.
>=20
> Greg has just begins with getting this started.

Exactly. Again, the problem is time. Deliberately breaking external
modules now and promising an in-tree alternative for later leaves
users out in the cold. That won't do much to improve the reputation
of Linux.

>> What solution do you propose?
>=20
> You list the drivers you currently have in mind at the Linux Driver=20
> Project [1].

They are all there already.

> Noone proposed to make the existance of out-of-tree modules completely =

> impossible - but it is a fact that derives directly from the Linux=20
> kernel development model that thre's no stable API for out-of-tree=20
> modules, and therefore each new kernel breaks many of them.

Granted.

> Once you accept this fundamental fact there's not much point in arguing=
=20
> that changes that break out-of-tree modules should be fewer.

Granted. But that's not the point I was arguing anyway.

There is still a point in arguing that breaking out-of-tree modules
is not a goal. It's acceptable collateral damage if there is a good
reason for a change, but it doesn't by and in itself constitute such
a reason. That's why I'm taking exception with your statement in
<20071024223124.GI30533@stusta.de>:
> [...] even though it might sound harsh breaking=20
> external modules and thereby making people aware that their code should=
=20
> get into the kernel is IMHO a positive point.

Breaking external modules is *not* positive. It's acceptable, but
everything else being equal it's still better to avoid it.

>>> Let me repeat that Greg has said he has hundreds of volunteers for su=
ch=20
>>> tasks.
>> Even with hundreds of volunteers, your proposed solution of just
>> rewriting *all* external code in a way fit for inclusion into the
>> kernel is an unachievable goal. Just look at the list on
>> http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
>> and try to answer why each of them is still out of tree.
>> Hint: In most cases it's neither out of malice nor stupidity on
>> the authors' part.
>=20
> There are different problems why different drivers are not (yet)=20
> included in the kernel, but which ones don't have any possible solution=
?

I'm convinced all of them have possible solutions. The challenge
is to turn a possible solution into an actual one. And again, the
problem is time.

> And if you compare the numbers you'll see that Greg has on average a=20
> handful of volunteers for one driver.

Not every problem can be solved faster by throwing more people at
it. Take mISDN as an example. Its developers have stated the goal
of inclusion in the main kernel tree years ago and it's still not
there. Deliberately breaking this external module "to make people
aware that their code should get into the kernel" would only delay
this goal even more. But sending them a handful of new volunteers
now would probably constitute the proverbial "adding manpower to a
late project".

> The most important question is still:
>=20
> Why should there always be out-of-tree code that fills a real need not =

> satisfied by any in-tree code?

Because every in-tree code starts as out-of-tree code, so as long
as there's development at all there's always a certain amount of
code which isn't in-tree yet - or of which it isn't even sure yet
whether it will get in-tree.

HTH

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enigB8E4E9B08C5222BB816C220E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHJnrnMdB4Whm86/kRAjVsAJ9od2dSPn1ubI5d1Hm95kxvNZrzdgCfcFE6
R7wqhxMlCOCk3F0beh3j7yE=
=oyjR
-----END PGP SIGNATURE-----

--------------enigB8E4E9B08C5222BB816C220E--
