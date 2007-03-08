Return-Path: <linux-kernel-owner+w=401wt.eu-S1030803AbXCHWYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030803AbXCHWYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030805AbXCHWYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:24:19 -0500
Received: from mse2fe2.mse2.exchange.ms ([66.232.26.194]:38831 "EHLO
	mse2fe2.mse2.exchange.ms" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030803AbXCHWYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:24:18 -0500
Subject: Permanent Kgdb integration into the kernel - lets get with it.
From: Piet Delaney <piet@bluelane.com>
Reply-To: piet@bluelane.com
To: Tom Rini <trini@kernel.crashing.org>
Cc: Piet Delaney <piet@bluelane.com>, Andi Kleen <ak@suse.de>,
       Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       sshtylyov@ru.mvista.com, Andrew Morton <akpm@osdl.org>,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@FreeBSD.org>
In-Reply-To: <20070308184940.GP11626@smtp.west.cox.net>
References: <20070307204516.GA24095@blade.az.mvista.com>
	 <200703081814.53153.ak@suse.de> <45F04B6E.9000703@mvista.com>
	 <200703081937.56167.ak@suse.de>  <20070308184940.GP11626@smtp.west.cox.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lISMxxOV0mk+qMGVR5Bb"
Organization: Blue Lane Technologies
Date: Thu, 08 Mar 2007 14:24:10 -0800
Message-Id: <1173392650.8912.236.camel@piet2.bluelane.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4-3mdk 
X-OriginalArrivalTime: 08 Mar 2007 22:24:16.0972 (UTC) FILETIME=[8240B8C0:01C761D0]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lISMxxOV0mk+qMGVR5Bb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 11:49 -0700, Tom Rini wrote:
> On Thu, Mar 08, 2007 at 07:37:56PM +0100, Andi Kleen wrote:
> > On Thursday 08 March 2007 18:44, Dave Jiang wrote:
> >=20
> > > In spite of kgdb, shouldn't it have that \n anyways in case some othe=
r code
> > > gets added in the future after the macro? Or are you saying that ther=
e should
> > > never be any code ever after that macro?
> >=20
> > Sure if there is mainline code added after that macro we add the \n.
> > But only if it makes sense to add code there, which it didn't in kgdb.
>=20
> Was that because with recent enough tools and config options there was
> enough annotations so GDB could finally figure out where things had
> stopped?  Thanks.

The reason Linus said he didn't allow George's kgdb mm patch to=20
be integrating into the kernel a year or two ago was that Amit and
George had significantly different implementations. So Amit, Tom,=20
George, and the rest of the kgdb development gang worked together=20
and came up with a unified version that we now support on SourceForge.=20

Tom rolled up a mm patch back in December for Andrew and then the
integration process stopped. I suggest we work together on getting
the kgdb patch back into the mm series and permanently into the kernel
like the kexec code and then we can avoid this kernel development
obfuscation.

-piet

=20
>=20
--=20
Piet Delaney                                    Phone: (408) 200-5256
Blue Lane Technologies                          Fax:   (408) 200-5299
10450 Bubb Rd.
Cupertino, Ca. 95014                            Email: piet@bluelane.com

--=-lISMxxOV0mk+qMGVR5Bb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBF8I0KJICwm/rv3hoRAqPgAJ9aFa6kCZXJKMdR8nQoGw+K9Y+CrwCdEq3n
KxKz+XgKuEhTP0AUucJ4dtU=
=xP13
-----END PGP SIGNATURE-----

--=-lISMxxOV0mk+qMGVR5Bb--

