Return-Path: <linux-kernel-owner+w=401wt.eu-S932281AbZHUOcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbZHUOcY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 10:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbZHUOcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 10:32:23 -0400
Received: from atreides.gradator.net ([212.85.155.42]:34888 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbZHUOcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 10:32:23 -0400
Date: Fri, 21 Aug 2009 16:32:23 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Sylvain Rochet <gradator@gradator.net>
Message-ID: <20090821143223.GA18008@gradator.net>
References: <ct4xS-63o-27@gated-at.bofh.it> <ba6a8e0d-946b-4d69-9f70-991e93c18f90@o15g2000yqm.googlegroups.com> <20090728164520.GB13662@gradator.net> <6278d2220908210405n35778e04mc1728f2c37ef0c0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <6278d2220908210405n35778e04mc1728f2c37ef0c0f@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 21, 2009 at 12:05:10PM +0100, Daniel J Blueman wrote:
>=20
> The reason I ask, I was chasing data corruption across the PCIe bus
> with some high-performance Quadrics interconnect adapters a while ago.
> The reproducer involved multiple outstanding main memory read requests
> to related addresses and a small block of data would be returned from
> the wrong offset.
>=20
> In the end, I found the nVidia CK804 (also MCP55) HT->PCIe bridge was
> at fault and later found disk corruption when doing heavy rsyncs to
> network. This was never publicly acknowledged, but I guess it
> illustrates the need for some micro-tests to verify data-soundness
> under duress; it took a day (and petabytes of data) of the production
> I/O workload to get this data corruption, and 3 seconds with the right
> reproducer, (still non-trivial to catch on a PCIe protocol analyser).
>=20
> Sometime I'll develop a stress-test driver for a common SATA or
> network controller to drive it's DMA engine with I/O patterns to and
> from main memory, checking the data integrity every few seconds; this
> could be generalised with OpenGL nicely for graphics cards on
> workstations I imagine.

Hehe, sounds interesting.

Sylvain

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKjq/2DFub3qtEsS8RAskBAJ4okhzlb+peD2EtrbQIz7W6YOBloQCeN/mg
OpRY58edKnXAfwnXYQIR3E8=
=mCja
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
