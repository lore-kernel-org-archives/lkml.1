Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXGPM1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXGPM1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 08:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbXGPM1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 08:27:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:41024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbXGPM1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 08:27:32 -0400
Date: Mon, 16 Jul 2007 14:27:20 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@in.ibm.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>
Subject: Re: Determine version of kernel that produced vmcore
Message-ID: <20070716122719.GA32519@suse.de>
Mail-Followup-To: Vivek Goyal <vgoyal@in.ibm.com>,
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
	Ken'ichi Ohmichi <oomichi@mxs.nes.nec.co.jp>
References: <20070710120243.GA10121@hmsendeavour.rdu.redhat.com> <20070713200533oomichi@mail.jp.nec.com> <20070713131550.GB10985@suse.de> <20070716041918.GA11390@in.ibm.com> <20070716115707.GA29923@suse.de> <20070716122518.GA10506@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20070716122518.GA10506@in.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Vivek Goyal <vgoyal@in.ibm.com> [2007-07-16 14:25]:
>=20
> Ok. Now there seems to be two ways for accessing such info.
> - Through global variables
> - Export through ELF notes.
>=20
> Personally, I like the approach taken by Dan Aloni of exporting required
> info through ELF notes. That seems to be more standard in the sense we=20
> are not dependent on somebody removing above variable tomorrow.
>=20
> Dan, are you planning to put the modified patch for discussions on LKML?

You mean the proposal with the makedumpfile-compatible ELF note?
Although I like that idea, I think Ken'ichi Ohmichi was against it.


Thanks,
   Bernhard

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGm2QniGU2lt2vZFQRAq3+AJ9qacACqSFfOwzRnVVbOJNzV6dTmQCeP8XA
YCPlvg1Q5IVl7csPB521teA=
=c7At
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
