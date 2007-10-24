Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXJXDXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXJXDXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 23:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXJXDW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 23:22:56 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47544 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbXJXDWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 23:22:54 -0400
Subject: Re: [PATCH 13/13] RT: Cache cpus_allowed weight for optimizing
	migration
From: Gregory Haskins <ghaskins@novell.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Darren Hart <dvhltc@us.ibm.com>
In-Reply-To: <200710240219.25487.ioe-lkml@rameria.de>
References: <20071023164156.5536.95573.stgit@novell1.haskins.net>
	 <20071023165130.5536.73345.stgit@novell1.haskins.net>
	 <200710240219.25487.ioe-lkml@rameria.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XQNHk6uqakokIvtkmvHc"
Date: Tue, 23 Oct 2007 23:20:12 -0400
Message-Id: <1193196012.8343.48.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XQNHk6uqakokIvtkmvHc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-24 at 02:19 +0200, Ingo Oeser wrote:

> Why not make it a task flag, since according to your code, you are only=20
> interested whether this is <=3D 1 or > 1. Since !(x <=3D 1) <=3D> (x > 1)
> for any given unsigned integer x, the required data structure is
> a "boolean" or a flag.

Hi Ingo,
  You are correct that the data is in fact interpreted as a boolean.  I
also had considered using a more boolean-like notation at one point.
However, I then figured I went through the expense of computing it, I
might as well store the actual value as an integer in case it can be
used in another way.  But to be honest, I cannot really think of any
other potential uses, so perhaps we would be best to follow your
suggestion.  It could always be changed if such a need ever arises.

Thank you for the feedback!

Regards,
-Greg



--=-XQNHk6uqakokIvtkmvHc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHHrnsSW61Ku6jJPkRAl2nAJwK9xrnW12gyC2glRc0dYpikqBIFgCfWve+
CbAT6MMlMsJlJcdhw71SNA4=
=iLyX
-----END PGP SIGNATURE-----

--=-XQNHk6uqakokIvtkmvHc--

