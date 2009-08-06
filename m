Return-Path: <linux-kernel-owner+w=401wt.eu-S1755406AbZHFOyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbZHFOyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZHFOyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:54:45 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:40799 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbZHFOyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:54:45 -0400
Date: Thu, 6 Aug 2009 16:54:43 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090806145443.GH26446@hawkmoon.kerlabs.com>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Benjamin Blum <bblum@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com> <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com> <20090805102057.GT29252@hawkmoon.kerlabs.com> <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com> <20090805164218.GB26446@hawkmoon.kerlabs.com> <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com> <20090806095854.GD26446@hawkmoon.kerlabs.com> <6599ad830908060328y21a008c1pc5ed5c27e0ec905d@mail.gmail.com> <20090806112450.GF26446@hawkmoon.kerlabs.com> <6599ad830908060440g2f6cbed6xdc54c7096cd3745e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-669-1249570450-0001-2"
Content-Disposition: inline
In-Reply-To: <6599ad830908060440g2f6cbed6xdc54c7096cd3745e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-669-1249570450-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06/08/09  4:40 -0700, Paul Menage wrote:
> On Thu, Aug 6, 2009 at 4:24 AM, Louis Rilling<Louis.Rilling@kerlabs.com> =
wrote:
> >
> > You meant signal_struct, right? sighand_struct can be shared by several
> > thread groups, while signal_struct can't.
> >
>=20
> No, I meant sighand_struct. I realise that it *can* be shared between
> processes, but I didn't think that NPTL actually did so. (Are there
> common cases of this happening?)

Not that I'm aware of, besides old LinuxThreads of course.

Thanks,

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-669-1249570450-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp67rMACgkQVKcRuvQ9Q1RH2gCfc4hlhWMj+LfNYTkBoRg8pB2C
YnYAoKd9N32zijGT+2Tu7nDLemZPhmZZ
=ODvo
-----END PGP SIGNATURE-----

--=_bohort-669-1249570450-0001-2--
