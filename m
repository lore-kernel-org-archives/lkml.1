Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbXISBGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbXISBGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 21:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbXISBGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 21:06:31 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:38994 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750910AbXISBGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 21:06:30 -0400
Date: Tue, 18 Sep 2007 21:06:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Combine instrumentation menus in kernel/Kconfig.instrumentation
Message-ID: <20070919010627.GA24174@Krystal>
References: <20070918211259.GA14927@Krystal> <14754.1190151939@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_Krystal-24630-1190163988-0001-2"
Content-Disposition: inline
In-Reply-To: <14754.1190151939@turing-police.cc.vt.edu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:01:09 up 51 days,  1:20,  4 users,  load average: 0.55, 0.53, 0.49
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_Krystal-24630-1190163988-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Tue, 18 Sep 2007 17:12:59 EDT, Mathieu Desnoyers said:
>=20
> > +++ linux-2.6-lttng/kernel/Kconfig.instrumentation	2007-09-18 13:18:17.=
000
> 000000 -0400
> > @@ -0,0 +1,40 @@
> > +menuconfig INSTRUMENTATION
> > +	bool "Instrumentation Support"
> > +	default y
> > +	---help---
> > +	  Say Y here to get to see options related to performance measurement,
> > +	  debugging, and testing. This option alone does not add any kernel c=
ode.
> > +
> > +	  If you say N, all options in this submenu will be skipped and disab=
led.
>=20
> OK, I'll bite - given the mention of 'debugging' there, do we want to go =
for
> broke and *also* suck in the 'Kernel Hacking' menu as well?

Instrumentation primarity aims at debugging user-space applications by
giving the ability to extract information across execution layers, hence
being a feature useful to users, not only kernel hackers. Therefore I
strongly doubt that it belongs to the kernel hacking submenu. It today's
world, where we face complex user-space problems involving
multithreaded, multiprocesses applications, the kernel and
hypervisors, running on many cores, this kind of tool has proven useful
to many, not only kernel developers. Please have a look at the
papers (especially the OLS2007 paper) linked on http://ltt.polymtl.ca as a
starting point if you are intereted in the question.

But yes, it can also be useful to kernel debugging, amongst other
things.

Mathieu


--=20
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

--=_Krystal-24630-1190163988-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG8HYTPyWo/juummgRAgBAAJ9jW3Puhidt6wkq3S8jfEF728KWmgCfcolZ
5eQhjB4HMOnwqYAuK1r72ZY=
=+0q5
-----END PGP SIGNATURE-----

--=_Krystal-24630-1190163988-0001-2--
