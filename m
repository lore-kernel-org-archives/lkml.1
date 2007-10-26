Return-Path: <linux-kernel-owner+w=401wt.eu-S1751948AbXJZKQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbXJZKQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 06:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750838AbXJZKQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 06:16:31 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:2698 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbXJZKQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 06:16:29 -0400
X-Greylist: delayed 1617 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 06:16:29 EDT
Message-ID: <4721B77F.8070102@imap.cc>
Date: Fri, 26 Oct 2007 11:46:39 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Adrian Bunk <bunk@kernel.org>, Simon Arlott <simon@fire.lp0.eu>,
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
Subject: Re: Linux Security *Module* Framework (Was: LSM conversion to static
 interface)
References: <Xine.LNX.4.64.0710210842540.551@us.intercode.com.au> <20071022210956.31f7bbcf@laptopd505.fenrus.org> <20071023051642.GA3908@sequoia.sous-sol.org> <471E9260.6000704@goop.org> <20071023220649.5a76af82@laptopd505.fenrus.org> <55615.simon.1193226629@5ec7c279.invalid> <20071024125533.GE30533@stusta.de> <471F8AC5.9080300@simon.arlott.org.uk> <20071024223124.GI30533@stusta.de> <4721221A.1020309@imap.cc> <20071026025647.GC21408@kroah.com>
In-Reply-To: <20071026025647.GC21408@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDD562C558CC5B09B87AF9E0D"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD562C558CC5B09B87AF9E0D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 25 Oct 2007 19:56:47 -0700, Greg KH wrote:
> On Fri, Oct 26, 2007 at 01:09:14AM +0200, Tilman Schmidt wrote:
>> Am 25.10.2007 00:31 schrieb Adrian Bunk:
>> > Generally, the goal is to get external modules included into the ker=
nel.
>> > [...] even though it might sound harsh breaking
>> > external modules and thereby making people aware that their code sho=
uld=20
>> > get into the kernel is IMHO a positive point.
>>=20
>> This argument seems to start from the assumption that any externally
>> maintained kernel code *can* get into the kernel, which doesn't stand
>> up to  reality. Once you admit that there is code which, for very good=

>> reasons, won't ever be accepted into the mainline kernel tree, what yo=
u
>> are saying amounts to: "Code that isn't fit to be included in the
>> mainline kernel isn't fit to exist at all."
>=20
> What kind of code is not accepted into the mainline kernel tree for goo=
d
> reasons?

- proprietary code
- unmaintained code
- code conflicting with existing kernel structure or policy
- code in which the concerned subsystem maintainers see no benefit
- code which its author is unable and/or unwilling to convert to
  kernel coding standards
- code whose author is unable and/or unwilling to defend it on LKML

> What are these reasons?

The details vary, but the fundamental reason is always the same: to
maintain a sufficient level of code quality in the kernel. Point in
case, the recent discussion whether drivers not supporting
suspend/resume should be refused to merge.

> What specific code are you talking about?

Some examples, in no particular order: Reiser4, AppArmor, VMware,
the staircase deadline scheduler, the first version of ser_gigaset,
the Matrox HAL module, SuSE's "taint extension". Yes, some of these
are in the kernel now, or have been superseded by other code that
is, but that doesn't invalidate my concern.

> I'm trying to compile a list of all known external modules and drivers
> and work to get them included in the main kernel tree to help prevent
> these kinds of things.  If you know of any that are not on the list at:=

> 	http://linuxdriverproject.org/twiki/bin/view/Main/OutOfTreeDrivers
> please feel free to add them, or email me with the needed information
> and I will add them to the list.

That's certainly helpful, but I still think there will always be
a number of external modules that cannot be merged right now or at
all, and deliberately making life difficult for out-of-tree code
maintainers in order to coerce them into submitting their code for
inclusion in the kernel will not work, it'll only create bad
feelings.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigDD562C558CC5B09B87AF9E0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHIbeIQ3+did9BuFsRAmVtAJ9SIP4Y+4GEHAgeMj0I+lMZKDYr8QCgmulL
14iQZFXuPP34q0BxxWUoKUE=
=7P+Z
-----END PGP SIGNATURE-----

--------------enigDD562C558CC5B09B87AF9E0D--
