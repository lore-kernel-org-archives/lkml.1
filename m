Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXISG4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXISG4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 02:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbXISG4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 02:56:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbXISG4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 02:56:43 -0400
Date: Wed, 19 Sep 2007 16:56:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 1/1] ppc64: Convert cpu_sibling_map to a per_cpu data
 array ppc64 v2
Message-Id: <20070919165623.8a59f4dd.sfr@canb.auug.org.au>
In-Reply-To: <20070917183507.506104000@sgi.com>
References: <20070917183507.332345000@sgi.com>
	<20070917183507.506104000@sgi.com>
X-Mailer: Sylpheed 2.4.5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__19_Sep_2007_16_56_23_+1000_I.2xQApTY_b1iczd"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2007_16_56_23_+1000_I.2xQApTY_b1iczd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Mon, 17 Sep 2007 11:35:08 -0700 travis@sgi.com wrote:
>
> v2:=20
>=20
> This patch applies after:
>=20
> 	convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
>=20
> and should fix the "reference cpu_sibling_map before setup_per_cpu_areas()
> has been called" problem.  In addtion, the cpu_sibiling_map macro has been
> removed [this was missed in my original submission.]

This one make it work, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__19_Sep_2007_16_56_23_+1000_I.2xQApTY_b1iczd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG8MggTgG2atn1QN8RAg/qAJ4+XjXxXxwprLwXZuKNOD0jdLARgACdG056
Ai/YzTQTgEZk3/c/IlVva5w=
=vBAz
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2007_16_56_23_+1000_I.2xQApTY_b1iczd--
