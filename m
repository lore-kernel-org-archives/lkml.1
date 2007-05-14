Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbXENTo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbXENTo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXENTox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:44:53 -0400
Received: from lug-owl.de ([195.71.106.12]:54706 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbXENTow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:44:52 -0400
Date: Mon, 14 May 2007 21:44:51 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, jcm@redhat.com
Subject: Re: [RFC] - LXR on kernel.org ? was: Re: What tools to use?
Message-ID: <20070514194451.GN27871@lug-owl.de>
Mail-Followup-To: devzero@web.de, linux-kernel@vger.kernel.org,
	jcm@redhat.com
References: <1783741195@web.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rzq/nSLlHy1djmXS"
Content-Disposition: inline
In-Reply-To: <1783741195@web.de>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Rzq/nSLlHy1djmXS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-11 10:06:17 +0200, devzero@web.de <devzero@web.de> wrote:
> Jesper Juhl <jesper.juhl () gmail ! com> wrote:
> > On 10/05/07, Shahbaz Khan <shaz.linux@gmail.com> wrote:
> > > All the experts on this list plz let me know of any good cross
> > > referencing tool for source code navigation. I have tried LXR but its
> > > not easy to configure for a rookie like me. Anyother as good as LXR?
> > >
> > lxr is pretty good (glimpse on its own as well can be useful). If you
> > don't want to set it up yourself, then you could consider to use the
> > online version at http://lxr.linux.no/

One "problem" with lxr.linux.no is that it's only updated from time to
time.  Maximilian Wilhelm and I added some preliminary GIT support to
LXR, and we're working on a patch to present the list of versions as
drop-down boxes (instead of a long link list.)

This should allow to index all and any tagged versions of the Linux
kernel and present them.  However, I don't have a box that's equipped
properly (HDD, CPU as well as network connectivity) to offer such a
setup, but I'd help in setting it up if somebody provides the machine!

> > Another good thing is "make ctags" in the kernel source dir - this
> > will  let you quickly jump to declarations etc and back with a few
> > simple keystrokes in editors like vim.
> > http://www.faqs.org/docs/ldev/0130091154_64.htm
> > http://applications.linux.com/article.pl?sid=3D07/01/22/167212&tid=3D13=
&tid=3D47
> > http://cscope.sourceforge.net/cscope_vim_tutorial.html
> >=20
> > "make cscope" is another good option. It'll generate an index usable
> > by the cscope tool (http://cscope.sourceforge.net/).
>=20
> I like lxr pretty much.
> i`m not a programmer, but i often need some information on "what`s
> the driver version of xyz in latest kernel" or "was this or that
> feature/patch already being merged" or "i have this line of code
> in kernel - how does it look in recent kernel , did it change " ?

You can easily get this information from http://git.kernel.org/git .

> why not adding a link to every kernel an kernel.org kernel,
> pointing to recent lxr`ed kernel source - or - even better -
> make lxr`ed kernel source part of kernel.org (so we
> have "B V VI 	C Changelog LXR" ) ?=20

I'd support the idea, but somebody needs to offer a machine or two and
enough bandwidth. (Though I hope that it's used rarely enough so that
only one machine is needed.)

> sure, i know kernel.org itself is very busy, but maybe this can
> be done via dedicated lxr machine/webserver someone is willing
> to donate !?

There's *no* way to add this to the current kernel.org machines.
There's quite some DB access during indexing, and making up the
sources on request takes some CPU cycles, too.

> for myself, i would happily donate some bucks for this.

As I said: If you manage to prepare the box, I'll offer to do the LXR
setup and automate the indexing.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
 Signature of:                      http://perl.plover.com/Questions.html
 the second  :

--Rzq/nSLlHy1djmXS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGSLwzHb1edYOZ4bsRAjC1AJ4gMtFUDqW0YjkJeYglGOixsfqfkgCgik5D
bBogUVOjwylcwAbWRpZ0xgw=
=cdrr
-----END PGP SIGNATURE-----

--Rzq/nSLlHy1djmXS--
