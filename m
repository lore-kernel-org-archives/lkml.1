Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbZD0HuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbZD0HuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZD0HuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:50:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:31477 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZD0HuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:50:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,253,1239001200"; 
   d="asc'?scan'208";a="407155203"
Subject: Re: Re-implement MCE log ring buffer as per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com>
References: <1240391484.6842.474.camel@yhuang-dev.sh.intel.com>
	 <20090422092259.GC18226@elte.hu> <20090422101600.GL3226@erda.amd.com>
	 <1240553210.6842.871.camel@yhuang-dev.sh.intel.com>
	 <20090424100943.GJ27264@erda.amd.com>
	 <alpine.DEB.2.00.0904240935140.24293@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1D1640od/stqvm9nDI4V"
Date: Mon, 27 Apr 2009 15:49:56 +0800
Message-Id: <1240818596.6842.1001.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1D1640od/stqvm9nDI4V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 21:36 +0800, Steven Rostedt wrote:
> On Fri, 24 Apr 2009, Robert Richter wrote:
> > >=20
> > > It seems that ring_buffer is not NMI-safe, while mcelog buffer will b=
e
> > > used in NMI context and interrupt context. When will ring_buffer to b=
e
> > > NMI-safe?
> >=20
> > You can use it in nmi context with separate read and write
> > buffers. See this patch description:
> > 6dad828b76c7224a22ddc9ce7aa495d994f03b31
> >=20
> > Not sure if somebody will make the ring_buffer non-locking.
>=20
> It already is ;-)
>=20
> I've put in for a patent application on the algorithm so I must wait till=
=20
> it is processed before I can release the code.

When will it be merged by mainline kernel? Do you have a plan?

We do have some scalability issues of current mcelog implementation, and
hopes that can be solved as soon as possible, perhaps for 2.6.31?

Best Regards,
Huang Ying


--=-1D1640od/stqvm9nDI4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn1Y48ACgkQKhFGF+eHlphJ1gCeJtyqIaAKPEYUSjBPh2rlVh7j
x1YAnRGTrauR/GMnRdxM8d7G6Dw3XrPl
=T3cn
-----END PGP SIGNATURE-----

--=-1D1640od/stqvm9nDI4V--

