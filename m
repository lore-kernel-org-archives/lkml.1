Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbXHUOH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbXHUOH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 10:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752761AbXHUOHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 10:07:16 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:13400 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618AbXHUOHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 10:07:15 -0400
Subject: Re: [RFC 2/9] Use NOMEMALLOC reclaim to allow reclaim if
	PF_MEMALLOC is set
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Christoph Lameter <clameter@sgi.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dkegel@google.com, David Miller <davem@davemloft.net>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <Pine.LNX.4.64.0708201415260.31167@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com>
	 <20070814153501.305923060@sgi.com> <20070818071035.GA4667@ucw.cz>
	 <Pine.LNX.4.64.0708201158270.28863@schroedinger.engr.sgi.com>
	 <1187641056.5337.32.camel@lappy>
	 <Pine.LNX.4.64.0708201323590.30053@schroedinger.engr.sgi.com>
	 <1187644449.5337.48.camel@lappy>
	 <Pine.LNX.4.64.0708201415260.31167@schroedinger.engr.sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-niSah3lF9HtkpNpdlAU2"
Date: Tue, 21 Aug 2007 16:07:11 +0200
Message-Id: <1187705231.6114.245.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-niSah3lF9HtkpNpdlAU2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 14:17 -0700, Christoph Lameter wrote:
> On Mon, 20 Aug 2007, Peter Zijlstra wrote:
>=20
> > > Its not that different.
> >=20
> > Yes it is, disk based completion does not require memory, network based
> > completion requires unbounded memory.
>=20
> Disk based completion only require no memory if its not on a stack of=20
> other devices and if the interrupt handles is appropriately shaped. If=20
> there are multile levels below or there is some sort of complex=20
> completion handling then this also may require memory.

I'm not aware of such a scenario - but it could well be. Still if it
would it would take a _bounded_ amount of memory per page.

Network would still differ in that it requires an _unbounded_ amount of
packets to receive and process in order to receive that completion.

--=-niSah3lF9HtkpNpdlAU2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGyvGPXA2jU0ANEf4RAuOWAJ49JV4ljK+gdOLW/2nTnFEC9qGVpgCfWwPr
IFXxD4k0PwA0Ynkv2tGmELY=
=u2JR
-----END PGP SIGNATURE-----

--=-niSah3lF9HtkpNpdlAU2--

