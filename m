Return-Path: <linux-kernel-owner+w=401wt.eu-S1759116AbXHXQKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116AbXHXQKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXHXQKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:10:40 -0400
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:42478 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752490AbXHXQKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:10:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=GXNiLFks71GQX2q1I9+eumHoAZg0SpDJntmC/TiifZy5JgRJ++Mr4F4RPnq9oKzVcF2OOu9bnSDUM49keUp3buGgg7ThNiTqcRtFlSma7YivVEyKJglsoSuDF5EBr/Nw4A6edgrl99LeTsLzQZL7jAB/hx+9pBM1fmBmIwHdjOY=  ;
X-YMail-OSG: uP3mlsgVM1kAAI2SfuBGs_x5zTJbWRwfzhoG5DEeFEgH103GpNzS9s_GUE9EQ9PtpjsAbJ9sd6uMVRfw6S27hVySStXCrJ2QR1_3AeRqkbuNIv4_
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 6/6] UML - Fix hostfs style
Date: Fri, 24 Aug 2007 18:10:24 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Satyam Sharma <satyam@infradead.org>, Joe Perches <joe@perches.com>
References: <20070817194342.GA8759@c2.user-mode-linux.org> <200708231655.00034.blaisorblade@yahoo.it> <20070824152127.GA7190@c2.user-mode-linux.org>
In-Reply-To: <20070824152127.GA7190@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2219293.37kV9msOPo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708241810.37052.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2219293.37kV9msOPo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On venerd=EC 24 agosto 2007, Jeff Dike wrote:
> On Thu, Aug 23, 2007 at 04:54:59PM +0200, Blaisorblade wrote:
> > > actually. Personally I'd prefer:
> > >
> > > 	else
> > > 		type =3D OS_TYPE_DIR;
> >
> > I strongly agree with this style; beyond style itself, one strong reason
> > is that joining statements hinder singlestepping through function code
> > (it's easy to run gdb on UML, and anyway kgdb exists).
>
> How does that help?  gdb should stop as easily on a "else foo;" line as on
> 	else
> 		foo;
> right?
Sorry, a better example is on:

	if (bar)
		foo;
where the test and foo are two distinct parts. One step is "I execute the i=
f",=20
another (possible) step is "I perform foo" - which is not easy to tell if i=
t=20
is not on a different line.
=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade
Linux registered user n. 292729
http://www.user-mode-linux.org/~blaisorblade

--nextPart2219293.37kV9msOPo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGzwL8qH9OHC+5NscRAuywAKCCinDnooJBuqasZi9nMMUUROSgiQCfflJ2
ZVRZ1urkm6xg9zdKkG+ioJ8=
=EDN/
-----END PGP SIGNATURE-----

--nextPart2219293.37kV9msOPo--
