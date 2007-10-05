Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbXJEHoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbXJEHoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 03:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbXJEHoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 03:44:01 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:14077 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753493AbXJEHoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 03:44:00 -0400
Subject: Re: [BUG] Linux 2.6.23-rc9 and MAX_ARG_PAGES
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mathieu Chouquet-Stringer <mchouque@free.fr>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>, Ollie Wild <aaw@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Eric Paris <eparis@redhat.com>
In-Reply-To: <20071005032211.GA3776@bigip.bigip.mine.nu>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
	 <m3wsu2u7y6.fsf@bigip.mine.nu>
	 <alpine.LFD.0.999.0710041023480.23684@woody.linux-foundation.org>
	 <20071004204443.GA28483@bigip.bigip.mine.nu>
	 <alpine.LFD.0.999.0710041413020.23684@woody.linux-foundation.org>
	 <18181.26846.253191.684845@cargo.ozlabs.ibm.com>
	 <alpine.LFD.0.999.0710041707260.23684@woody.linux-foundation.org>
	 <20071005032211.GA3776@bigip.bigip.mine.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4DBXo+MkIJ5udYN0Abvk"
Date: Fri, 05 Oct 2007 09:43:57 +0200
Message-Id: <1191570237.22357.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4DBXo+MkIJ5udYN0Abvk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 05:22 +0200, Mathieu Chouquet-Stringer wrote:
> On Thu, Oct 04, 2007 at 05:12:11PM -0700, Linus Torvalds wrote:
> > I also tested that "ulimit -s" seems to do the right thing for me.
> >=20
> > I'm also assuming Mathieu is running x86 (or x86-64): HP-PA has a stack=
=20
> > that grows upwards, and that has traditionally been exciting.
>=20
> Correct, x86 it is but as I said it's this stupid auditd thing that
> breaks the whole process.  I'm gonna file a bug against it.

Eric Paris just posted patches to solve this.

--=-4DBXo+MkIJ5udYN0Abvk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHBes9XA2jU0ANEf4RAhvNAJ9dWz1jnRSxb1PcbpHgpcUdvTnGPgCghY3S
4x/lk54D3XN3S9CuImMOOjQ=
=iiX/
-----END PGP SIGNATURE-----

--=-4DBXo+MkIJ5udYN0Abvk--

