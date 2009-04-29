Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbZD2GvH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbZD2GvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:51:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbZD2Guw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:50:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:14820 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752305AbZD2Guv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:50:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,265,1239001200"; 
   d="asc'?scan'208";a="407871122"
Subject: Re: [PATCH -v2] x86: MCE: Re-implement MCE log ring buffer as
 per-CPU ring buffer
From: Huang Ying <ying.huang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090429061148.GQ27382@one.firstfloor.org>
References: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com>
	 <87eivdqdsq.fsf@basil.nowhere.org>
	 <1240968709.6842.1175.camel@yhuang-dev.sh.intel.com>
	 <20090429061148.GQ27382@one.firstfloor.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VmXW3zihm3cGd6xfNgac"
Date: Wed, 29 Apr 2009 14:50:48 +0800
Message-Id: <1240987849.6842.1209.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VmXW3zihm3cGd6xfNgac
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-29 at 14:11 +0800, Andi Kleen wrote:
> > Maybe the comment is a little confusing. What we do is limit the size o=
f
> > user buffer size to prevent system from not response. If the user buffe=
r
>=20
> Ah. The standard way to handle this is to add cond_resched()s where
> appropiate. Maybe that would be an alternative or is that not
> possible? You have to drop locks of course.

Yes, I will use cond_resched() instead.

Best Regards,
Huang Ying

--=-VmXW3zihm3cGd6xfNgac
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn3+MUACgkQKhFGF+eHlph2VACdEXc+sIUNoQ4wesP28g82Ckx0
plgAnjY2Dyyf/4+7u/mmXTiYflp6MyN6
=xpdE
-----END PGP SIGNATURE-----

--=-VmXW3zihm3cGd6xfNgac--

