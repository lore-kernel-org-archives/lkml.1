Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYJUGsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYJUGsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 02:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbYJUGrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 02:47:52 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYJUGrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 02:47:51 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Johannes Berg <johannes@sipsolutions.net>
To: benh@kernel.crashing.org
Cc: Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       linux-pci@vger.kernel.org, yhlu.kernel@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <1224538518.7654.164.camel@pasglop>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
	 <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu>
	 <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop>
	 <2008102  <20081020113602.GA2697@elte.hu>
	 <1224507486.27899.31.camel@johannes.berg>
	 <1224538518.7654.164.camel@pasglop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e3lXRRFrItNsUStAzToZ"
Date: Tue, 21 Oct 2008 08:47:29 +0200
Message-Id: <1224571649.27899.73.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e3lXRRFrItNsUStAzToZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 08:35 +1100, Benjamin Herrenschmidt wrote:
> On Mon, 2008-10-20 at 14:58 +0200, Johannes Berg wrote:
> > On Mon, 2008-10-20 at 13:36 +0200, Ingo Molnar wrote:
> >=20
> > > +	/* room for the actual number, the "0x" and the final zero */
> > > +	char sym[2*sizeof(phys_addr_t) + 2];
> >=20
> > Buffer overflow.
>=20
> It's actually not going to overflow as we pass the end of the buffer to
> "number" but we'll miss a digit.

"buf" won't overflow, but "sym" will, no? Anyway, +3 is the correct
thing to do.

johannes

--=-e3lXRRFrItNsUStAzToZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/Xr9AAoJEKVg1VMiehFYAtIP/iJV5VlO+Gnth9KzRnKG4B8k
bC0LF9Q5uIxxSv4pZgLOiLAfVsEpMb7N8BztQ+9DplkFbFOGDeVTpBgCaQb2arIO
lsxN9hhP2bVwjqQdMnOzB3i69rLpFG8vFMXWajQg+RF3+a/ntLyqnKtlIdQAikKS
PsVoEliwrTHf1tIKcjvVycGVYYayhlB3EOUh7MAjNIy4HT1CbPyKcaXt0hc22w3u
jWZzZ7ceU2uFlMKLPpeI+eX3GXHCGWMPmTVVFXzGd+nkv0aD42edUGIktYQNR9N8
r/BZVYxvo58UrsRKGqBbAdhyHOXnLoyNAdxXgcvDMCr8HCp0tJPpejchrj0kjuAa
GtkJ6oH/0RBSBLfqp2Ib2kuWlg19KkHSX1ctEKzFxWsL4GqKXofEzUqpG2fqocZX
U9SXQwyG/4l+cZJwZD3Qybj5GZbJXeee5fVinrqssSh42jh9/kQFMmUJah9Dcyi+
h2QNu8fFrlgqumK+wJ+KFmQZ9AdAZ76PH39jOKq7Hmn/GU1S6uFCDQPlhd2zY5Dd
bohXJ6UqN6voE41EAbQgdWdIR+/pfvC6h0cnXjJBoLOiIqSyE3Fn+ZXXCzyijgFM
8qX6Di3VXIjnMLLu201OLQ2BJ0TQf9okWTkKuTtzB/Qb4tFy+051wFZ8h35T9Ise
btYZuWGR+mNr+472dz3i
=Gl+r
-----END PGP SIGNATURE-----

--=-e3lXRRFrItNsUStAzToZ--

