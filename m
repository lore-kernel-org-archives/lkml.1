Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbZKWPqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbZKWPqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755498AbZKWPqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:46:42 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:48188 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbZKWPql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:46:41 -0500
Subject: Re: kvmmmu tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <srostedt@redhat.com>
Cc: kvm <kvm@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1258988338.31359.147.camel@localhost.localdomain>
References: <1258974375.7094.158.camel@johannes.local>
	 <1258988338.31359.147.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UgvE0UhMoQepdxw4NHzi"
Date: Mon, 23 Nov 2009 16:46:10 +0100
Message-ID: <1258991170.7094.173.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-UgvE0UhMoQepdxw4NHzi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-23 at 09:58 -0500, Steven Rostedt wrote:
> On Mon, 2009-11-23 at 12:06 +0100, Johannes Berg wrote:
> > Commit f691fe1da7e2715137d21ae5a80bec64db4625db is really broken wrt.
> > the userspace interface for tracing because of the weird
> > KVM_MMU_PAGE_PRINTK macro.
> >=20
> > Maybe we should have a "unsafe for export" flag for events, if they do
> > strange things like that?
> >=20
> > As it stands, I can't use trace-cmd on an x86 machine that has kvm
> > enabled because it will try to read all the kvm stuff. Arguably, it
> > should only try to parse it when it needs it (i.e. not for me) but stil=
l
> > it's very inconvenient to export something to userspace that it cannot
> > possibly understand.
>=20
> Note, I updated trace-cmd. I still does not read this macro nicely, but
> it at least does not fail anymore.

Ah, good to know. So I guess I don't care any more since I'm not
actually tracing this. However, since trace-cmd is very convenient for
record + send-by-email + report/analyse, it might make sense to fix
anyway.

johannes

--=-UgvE0UhMoQepdxw4NHzi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLCq4+AAoJEODzc/N7+QmasfoQAJiOmDiAeNm/f0qWDGl/NOOu
ZF3qP0YeknOsQBwGmlXr4vSQJOQeSUtlnX2Jq4MxtrGwQ/zlJMukQNoOpQRc12xE
uRri4Vb9dNv7PiypUa1/zb0NhSHwjdFu/Boor3i19WhosCXtyacOER/j0JxECpKy
l8tXWhH3wxFOLcKFxR5MPVaMtyoVITFL6nNPIMlo+D1UO5W0p706VSaIKzYN7jTS
YM5yreoe4uSpjPzIZFInVpkDgMUSdo0WGjdvSVpTA6ylCEYSvIb7FrS6CgO9es3+
dmjrAWUnpw80s1tgOlwfzq/4dqT3cUocFnnn+xg9WSN/hjB/iR91U3N81dt8gKYx
itBebhOey7SQGxzSdiuRtlv6VmuaygMZshOYrKb4KfAyA2jGHvY4bDRNghnIP+wM
I6/fkFZdD+mMr41p+FP6mw8L+2vPL8HaUjO/7+HBBZOiUEifTR/pMJP2UwoPIYap
FZZkBYmfY+r8M+k64IIj5l4cYH1pQYiT5hSpoSxXw2h1jhzbQ37ZfdqggqKjPIap
JQIfA2uBgnj3IL2PM92z7sWMetKdmekvcHet6c6wMD4bD3zTNUDYUNhvGugyMw9K
8hO2BYVXFaJKpw1oamDVTHJq1u/YorBmAUzsD15X1igWy/iaTy1OY4bK5WXw3weO
eJPbeY0mtdDjl26DULOm
=xySr
-----END PGP SIGNATURE-----

--=-UgvE0UhMoQepdxw4NHzi--

