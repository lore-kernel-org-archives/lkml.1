Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZCCFlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZCCFlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 00:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZCCFlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 00:41:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:37703 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZCCFlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 00:41:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,294,1233561600"; 
   d="asc'?scan'208";a="391115897"
Subject: Re: [PATCH] Fix e820 end address with EFI
From: Huang Ying <ying.huang@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Maly <bmaly@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49ACC205.2040504@kernel.org>
References: <49A965AD.10701@redhat.com>
	 <86802c440902282142p14f623b8td8a88600ff2a6bbe@mail.gmail.com>
	 <49AAEC79.3000808@redhat.com>
	 <1235956068.6204.143.camel@yhuang-dev.sh.intel.com>
	 <49AB38E7.60305@redhat.com>
	 <1235960016.6204.170.camel@yhuang-dev.sh.intel.com>
	 <49AB4171.7000508@kernel.org>
	 <1235960708.6204.176.camel@yhuang-dev.sh.intel.com>
	 <49AB4521.8010909@kernel.org>
	 <1235961428.6204.190.camel@yhuang-dev.sh.intel.com>
	 <86802c440903011851t17e240eu9dc25116a40ca85e@mail.gmail.com>
	 <1235979959.6204.212.camel@yhuang-dev.sh.intel.com>
	 <49AC51D7.1080203@kernel.org>
	 <1236042459.6204.226.camel@yhuang-dev.sh.intel.com>
	 <49AC87AE.60001@kernel.org>
	 <1236046936.6204.243.camel@yhuang-dev.sh.intel.com>
	 <49AC9B99.5020000@kernel.org>
	 <1236049574.6204.253.camel@yhuang-dev.sh.intel.com>
	 <49ACAAAF.90300@kernel.org>
	 <1236058371.6204.267.camel@yhuang-dev.sh.intel.com>
	 <49ACC205.2040504@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o/paKqoOa8RgRLzDS/aq"
Date: Tue, 03 Mar 2009 13:40:58 +0800
Message-Id: <1236058858.6204.273.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o/paKqoOa8RgRLzDS/aq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-03 at 13:37 +0800, Yinghai Lu wrote:
[...]
> > The dmesg with ignore_loglevel in kernel parameters is attached with th=
e
> > mail.
> >=20
> > init_memory_mapping: 0000000000000000-000000003f700000
> >  0000000000 - 003f600000 page 2M
> >  003f600000 - 003f700000 page 4k
> > kernel direct mapping tables up to 3f700000 @ 8000-b000
> > last_map_addr: 3f700000 end: 3f700000
> >=20
> > init_memory_mapping: 00000000fffb0000-00000000fffba000
> >  00fffb0000 - 0100000000 page 4k
> > last_map_addr: 100000000 end: fffba000
> that is funny, the range calculating has some problem...when the range si=
ze < 2M...

Yes. Can you fix that? If you have no time, I can do that.

Best Regards,
Huang Ying


--=-o/paKqoOa8RgRLzDS/aq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmswucACgkQKhFGF+eHlphItACeLRe9Vwqtikt78DiEhywCFwGu
0awAoJt/FcqGYl0CB4EYtRGfNnTxVb5C
=Uevd
-----END PGP SIGNATURE-----

--=-o/paKqoOa8RgRLzDS/aq--

