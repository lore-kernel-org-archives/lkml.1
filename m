Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0CEPkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 10:40:15 -0500
Received: from light.bluelinux.co.uk ([195.10.223.138]:40237 "EHLO
	light.bluelinux.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0CEPkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 10:40:13 -0500
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Mar 2010 10:40:13 EST
Date: Fri, 5 Mar 2010 17:40:09 +0200
From: Daniel Stone <daniel@fooishbar.org>
To: David Miller <davem@davemloft.net>
Cc: skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [git pull] drm request 3
Message-ID: <20100305154009.GC2505@tempa>
Mail-Followup-To: Daniel Stone <daniel@fooishbar.org>,
	David Miller <davem@davemloft.net>, skeggsb@gmail.com,
	airlied@linux.ie, linux-kernel@vger.kernel.org,
	jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu,
	torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk> <20100305.063718.211238119.davem@davemloft.net> <20100305151754.GB2505@tempa> <20100305.072612.186421758.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <20100305.072612.186421758.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Mar 05, 2010 at 07:26:12AM -0800, David Miller wrote:
> From: Daniel Stone <daniel@fooishbar.org>
> > On Fri, Mar 05, 2010 at 06:37:18AM -0800, David Miller wrote:
> >> If it effects such a large number of people, which this noveau thing
> >> does, it's entirely relevant to everyone.  And the way it's breaking
> >> and making kernel development difficult for so many people matters to
> >> us.
> >=20
> > Maybe the lesson to be learned from all this is, 'if the developers
> > don't want something merged because they're not ready and forsee huge
> > problems in the future, actually listen to them instead of blindly
> > ramming it in regardless'? But maybe that's just me.
>=20
> That's doesn't work, and it never will.
>=20
> First of all, if we didn't merge the driver Fedora users wouldn't be
> able to test the upstream kernel at all.
>=20
> And if you think things through, there is one and onle one set of
> actions that would have made things work properly.
>=20
> And that's merge the driver upstream and not break user visible APIs.

Ah, argument by assertion.  That's my most favourite thing to deal with
on a Friday evening.

Wait, did I say 'most'? I meant least.

> In fact, I argue that the moment nouveau went into Fedora and
> was turned on by default, the interfaces needed to be frozen.

That's a matter for the Fedora kernel team; for better or worse, they
made the choices they did, which included going through all the relevant
pain to support this.  They didn't consider it suitable for upstream
because they didn't think everyone else should be forced to endure that
pain.

Now it's upstream and everyone's being forced to deal with it.  Great.

> Consider if it didn't go upstream and I want to do upstream
> kernel development, ok so I patch the noveau-of-the-moment into
> my upstream tree.
>=20
> Six months and 10 DRM library updates later I go back and try to boot
> that kernel.  And it's not going to work.

nouveau isn't going to work, no.  vesa and nv remain unaffected; it's
not like it's some kind of catastrophic failure whereby booting it eats
your disk and gropes your sister-in-law.

> So if the user visible APIs are changed in any set of situations
> (upstream merged, not upstream merged, etc.) things can end up
> breaking.

Correct!

> Ergo, you simply can't sanely do it at all.  You have to have
> a compatability story when you change these things.

You cannot sanely do it at all in an upstream kernel, no.

> Personally I wouldn't have ever committed to that "user visible APIs
> can break cause it's in -stable."  Because that's complete garbage.

I guess you mean staging here; either way, that's a matter for you guys
to deal with.  I guess the upshot here is 'if you merge something
against the developers' wishes by screaming at them until they comply,
they repeatedly tell you that it's not API-stable, you merge it, and it
changes API, then joke's on you'.  If the result of this ridiculous mess
is that anything merged to staging is never allowed to change userspace
ABI ever, then great.  As I said, it's really not my problem.

Either way, fuck it, it's Friday.  To the pub.

Cheers,
Daniel

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuRJdkACgkQUVYB1rKAgJS2cwCg3bP8S6NSCTvmxpVbCMkZsPtO
9YgAmwQQv1eboUhApjsxr4JLJgm7VNjj
=7CAW
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
