Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbZELJkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbZELJkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZELJkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:40:33 -0400
Received: from mail46.e.nsc.no ([193.213.115.46]:57050 "EHLO mail46.e.nsc.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbZELJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:40:32 -0400
Date: Tue, 12 May 2009 11:40:02 +0200
From: Henrik Austad <henrik@austad.us>
To: Jussi Laako <jussi@sonarnerd.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
       James Courtier-Dutton <James@superbug.co.uk>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class, take 2
Message-ID: <20090512094002.GA26113@januz.myftp.org>
References: <4959198A.3020209@sonarnerd.net> <1230622925.16718.26.camel@twins> <4959DE51.2020605@sonarnerd.net> <1231756114.19771.6.camel@laptop> <496C6294.2040707@sonarnerd.net> <4971D3D5.6040801@superbug.co.uk> <497CF128.2060903@sonarnerd.net> <1232954745.4863.4.camel@laptop> <4A07E044.8040807@sonarnerd.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <4A07E044.8040807@sonarnerd.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 11, 2009 at 11:22:28AM +0300, Jussi Laako wrote:
> Hi,
>=20
> Peter Zijlstra wrote:
> [..]
> > And 2), the kernel can help by providing a deadline based scheduler,
> > which should make the above easier and less likely to mess up the rest
> > of the system. ie. a deadline scheduled application will not exceed its
> > allotted budget, unlike a FIFO scheduled app.
>=20
> Any news on this one?

I'm still working on my SCHED_PFAIR stab. Expect an RFC someday soon

pfair is a deadline-driven algorithm that also executes the tasks at a=20
steady rate, minimizing jitter as well as meeting deadlines. This give=20
tasks better expressiveness when it comes to instructing the scheduler how=
=20
to treat the task. I'll give a more formal intro in the upcoming RFC :)

--=20
henrik


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoJQ/IACgkQ6k5VT6v45lk1JQCfXoNDlhsXc5hGBi7R+vro32fM
WyAAn0oHYyAdkt/gRLQwj5gWL3LJo62F
=aO2B
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
