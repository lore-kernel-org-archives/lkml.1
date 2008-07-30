Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYG3CfE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYG3CfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:35:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752569AbYG3Cex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:34:53 -0400
Received: from ozlabs.org ([203.10.76.45]:49975 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYG3Cex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:34:53 -0400
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Bastian Blank <waldi@debian.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080728185651.GA29530@wavehammer.waldi.eu.org>
References: <20080728185651.GA29530@wavehammer.waldi.eu.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y3b41xOQjJnxNaVmOM9m"
Date: Wed, 30 Jul 2008 12:34:51 +1000
Message-Id: <1217385291.10646.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y3b41xOQjJnxNaVmOM9m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
> Hi

Hi Bastian,

> The powerpc lpar code adds a prefered console at a very early state,
> during arch_setup. This runs even before the console setup from the
> command line and takes preference.

It runs before the command line parsing, and so /does not/ take
preference. I thought.

/**
 * add_preferred_console - add a device to the list of preferred consoles.
 ...
 * The last preferred console added will be used for kernel messages
 * and stdin/out/err for init.=20

The last console will be added by the console=3D parsing, and so that will
be used. The console we add in the pseries setup is only used if nothing
is specified on the command line.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-Y3b41xOQjJnxNaVmOM9m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIj9NLdSjSd0sB4dIRAunJAJ94BN9WrelhYf0rWSgTLAt0XmtyrgCgp603
po+W7JX3TSKq5q+01o9UNHQ=
=e8ud
-----END PGP SIGNATURE-----

--=-Y3b41xOQjJnxNaVmOM9m--

