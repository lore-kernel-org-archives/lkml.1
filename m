Return-Path: <linux-kernel-owner+w=401wt.eu-S1758339AbXFMOYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339AbXFMOYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbXFMOYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:24:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:59957 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751618AbXFMOYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:24:39 -0400
X-Authenticated: #153925
X-Provags-ID: V01U2FsdGVkX19k6ypIvcBkyy+NTKCYuG8K7d8jgq5sZa+GoQU5WC
	ux7WGavWNbdz46
From: Bernd Paysan <bernd.paysan@gmx.de>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 13 Jun 2007 16:24:36 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <466A3EC6.6030706@netone.net.tr> <200706131402.11396.bernd.paysan@gmx.de> <m33b0w80dg.fsf@maximus.localdomain>
In-Reply-To: <m33b0w80dg.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart14413746.RRYkQWn6l8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706131624.37211.bernd.paysan@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart14413746.RRYkQWn6l8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 13 June 2007 15:11, Krzysztof Halasa wrote:
> > The GPLv2 however is very clear how the end user gets the license: from
> > the original author.
>
> I'd be surprised if it's for GPL to decide.

If you choose the GPL as license, the text of the GPL are the conditions.=20
Otherwise, the GPL would be pure nonsense (as would be any other license).

> > Not from the man in the middle, from a distributor or
> > kernel maintainer, who can neither add nor drop
> > restrictions/permissions (and thus the special rights of a compilation
> > editor are void). The author can only speak for himself, not by behalf
> > of somebody else, as well as the compilation editor.
>
> How about derived works?
> Am I free to get BSD source, incorporate it in GPL project, and release
> the whole under GPL?
> Sure, the original source stays BSD but I don't distribute it.

Derivated work is a product of several authors, therefore each author may=20
put different conditions on his part of the work - as long as they are=20
compatible, it's ok. A derivated work originally under BSD, now with a=20
patch under GPL can only be distributed under GPL, but not under BSD=20
(because GPL requires redistribution under GPL, whereas BSD doesn't care).=
=20
If you take out the patch, and revert the work to the BSD one, you are free=
=20
to redistribute it under BSD.

There's no point of discussing that the Linux kernel *as a whole* (as=20
compilation) currently is under GPLv2 only, since it sais so, and a few=20
files also explicitely say so. The whole combination is GPLv2 only, but=20
most parts aren't.

> > That's why the FSF is so strict about having each
> > author stating copyright and the license conditions on the top of the
> > file - nobody else can.
>
> I'm not sure the copyright laws define "files".

Copyright law defines "work", and in terms of computer programs, source=20
code "work" goes into files. Or patches, but patches end up distributed=20
over several files.

The nice thing about this is that you can make automatic checks about the=20
license you actually have to fulfill. E.g. if you compile a hypothetical=20
Linux 2.8.15.3 without ZFS and dtrace in 2009, you may end up with=20
compiling only GPLv2-compatible code, and therefore can tivoize your system=
=20
(unless you sell it to Germany, where the GPLv2 outlaws tivoizing by=20
intent), but if you add either ZFS or dtrace, you can't.

> > So my conclusion is: If you, as contributor to the Linux kernel, want
> > to make clear that your work really is GPLv2 only, you have to do that
> > yourself, you have to add a notice like above to files where you
> > exclusively own copyright.
>
> I don't think the law works like that.
> By default you have no rights to someone's work (file or project).
> The only licence I can find with Linux is GPL v2, isn't it?

Yes, and the GPLv2 sais "if the FSF releases a new version of the GPL, you=
=20
may update" (section 9):

"  9. The Free Software Foundation may publish revised and/or new versions
of the General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

Each version is given a distinguishing version number.  If the Program
specifies a version number of this License which applies to it and "any
later version", you have the option of following the terms and conditions
either of that version or of any later version published by the Free
Software Foundation.  If the Program does not specify a version number of
this License, you may choose any version ever published by the Free Software
=46oundation."

This is normal contract law (you have to say "yes" to a new M$ EULA every=20
few months or so if you are an unlucky Windows user, and like to use their=
=20
patches), contracts can change over time. The FSF is rather nice here, they=
=20
say users and contributors can make choices to which contract they use.

Given that the license you find with Linux is GPLv2, anyway, the comment=20
from Linus seems to be superfluous. The license already says which version=
=20
it is. But it has this upgrade option, and one possible interpretation of=20
Linus' comment is "no, it doesn't have this update option".

> And even=20
> that wasn't stated explicite until that 2.4.0something (though there
> is a consensus that the COPYING file was indeed a licence for the
> whole kernel).
>
> Then you may have additional rights, such as those given in various
> source files.
>
> > The rest (the majority) did not
> > choose to say anything, which under the GPL regime means "any";
>
> What exactly is the "GPL regime" and how is it defined by copyright
> law and/or the GPL licence itself (or will of copyright holders etc.)?

If I use GPL as license, I'm under "GPL regime", i.e. the terms of the GPL=
=20
apply. The GPL requires that I need to speak up explicitely if I want to=20
limit the choice of licenses - if I don't say anything, it defaults to "any=
=20
GPL". This is a restriction that goes from author to user, sinde the GPL=20
cuts away all middle-men (restrictions applied by middle-men can be=20
reverted).

If I decide to build my own compilation of Linux kernel patches* (i.e. a -b=
p=20
kernel, like the -mm kernel is a different compilation of Linux kernel=20
patches as the mainline kernel), I'm free to choose under which conditions=
=20
I redistribute it, given that it's compatible with the conditions the=20
original authors have chosen. Most of them have said nothing (other than=20
implicitely that it's ok for them to put it under GPL, as they haven't=20
opposed to inclusion into the Linux kernel), some have said GPLv2 or later,=
=20
some say GPLv1.1 or later (e.g. the parport driver) and a few have=20
said "GPLv2 only". Now, I may rewrite those few "GPLv2 only" files, and=20
then I have a GPLv2-or later compatible linux-some.version-bp kernel. And=20
into this kernel, I can add code under GPLv3 (once the GPLv3 is ready and=20
there's code worth to add under GPLv3), which limits me to redistribute the=
=20
whole thing under GPLv3.

=2D-=20
Bernd Paysan
"If you want it done right, you have to do it yourself"
http://www.jwdt.com/~paysan/

--nextPart14413746.RRYkQWn6l8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGb/4li4ILt2cAfDARAj7ZAKDdAa+vo+JSuPeHF8jeUGfwHaBehQCcDhCW
4ZAi7uOlov57K1ixOlYaf4E=
=p0h6
-----END PGP SIGNATURE-----

--nextPart14413746.RRYkQWn6l8--
