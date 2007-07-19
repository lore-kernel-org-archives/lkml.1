Return-Path: <linux-kernel-owner+w=401wt.eu-S940815AbXGSR21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940815AbXGSR21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 13:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937340AbXGSR2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 13:28:08 -0400
Received: from lisa.in-ulm.de ([217.10.8.8]:54666 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S938022AbXGSR2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 13:28:06 -0400
Date: Thu, 19 Jul 2007 19:24:20 +0200
From: Christian Ehrhardt <lk@c--e.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Christian Ehrhardt <lk@c--e.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070719172420.GA5914@lisa.in-ulm.de>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070718183503.541026f8.akpm@linux-foundation.org> <20070719073948.GI18840@lisa.in-ulm.de> <20070719122424.GA5186@vino.hallyn.com> <1184864070.2694.3.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <1184864070.2694.3.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 19, 2007 at 09:54:30AM -0700, Arjan van de Ven wrote:
> the next step after this patch is to have an option to get rid of all
> the function pointer chasing (which is expensive) for the case where you
> know you only want one security module (which you then can turn on or
> off)... that advantage is a performance gain for a lot of people....

I'm pretty sure that at least the security_ops function pointers could be
resolved statically with some proprocessor trickery right now.

E.g. define macros for the security_* hooks in the single security module that
is configured statically and include those defines in security.h instead
of the prototypes for the inline functions. Am I missing something?

If a distribution enables such an option there is no way to load a
security module, true. This is what we have right now if the distro disables
loadable module support or disables security modules.

       regards   Christian


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGn55EDWylJVHJF/wRAiGkAKC9jMOPn+iGLXGEmSPG7oNz2BrKywCgwrPV
ggGqe7umrYHO4JFXyVgFA/I=
=AWY8
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
