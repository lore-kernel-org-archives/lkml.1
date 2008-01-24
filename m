Return-Path: <linux-kernel-owner+w=401wt.eu-S1756262AbYAXS2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262AbYAXS2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 13:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbYAXS2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 13:28:33 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33217 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYAXS2c (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 13:28:32 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [PATCH] Linux Kernel Markers Support for Proprierary Modules
In-Reply-To: Your message of "Thu, 24 Jan 2008 07:47:04 EST."
             <20080124124703.GB32559@Krystal>
From: Valdis.Kletnieks@vt.edu
References: <1201029235.18144.62.camel@perihelion> <y0modbdnt4e.fsf@ton.toronto.redhat.com> <20080123031005.GA16766@Krystal> <1201061860.25284.28.camel@perihelion> <20080123131442.GA6562@redhat.com> <20080123144811.GA12296@Krystal> <27267.1201152358@turing-police.cc.vt.edu> <1201155569.25284.88.camel@perihelion>
            <20080124124703.GB32559@Krystal>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1201199261_2846P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Jan 2008 13:27:41 -0500
Message-ID: <32308.1201199261@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1201199261_2846P
Content-Type: text/plain; charset=us-ascii

On Thu, 24 Jan 2008 07:47:04 EST, Mathieu Desnoyers said:
> I am throwing this one-liner in and let's see how people react. It only makes
> sure that a module that has been "forced" to be loaded won't have its markers
> used. It is important to leave this check to make sure the kernel does not crash
> by expecting the markers part of the struct module by mistake in the case there
> is an incorrect checksum.

I can live with that - if anything, a force-loaded GPL module deserves to lose
even more than a non-GPL module built against the current kernel.  Quite
frankly, given that one of the reasons given for not liking closed modules is
"it's not maintainable", you'd *expect* that the infrastructure for allowing
a force-load of a module would have been thrown out entirely - is there anything
more unmaintainable than a module you *know* was built against different headers
and thus is using the wrong offsets for things?

--==_Exmh_1201199261_2846P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHmNidcC3lWbTT17ARAlB/AJ9G25qJ0YSrYLH3CNGSSQmJvEx66QCeMzkw
tRfCt1R06pgmjHqJ1G2rOJo=
=UcNe
-----END PGP SIGNATURE-----

--==_Exmh_1201199261_2846P--
