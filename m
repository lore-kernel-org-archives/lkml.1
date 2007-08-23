Return-Path: <linux-kernel-owner+w=401wt.eu-S1764682AbXHWOzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764682AbXHWOzQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762332AbXHWOzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:55:05 -0400
Received: from smtp010.mail.ukl.yahoo.com ([217.12.11.79]:38309 "HELO
	smtp010.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762313AbXHWOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:55:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=nAEdwPALM+74yJA0Ojc4MVTDvriofAgDEusLTvtr8QnObaBJBhcluG+dXxDo7JNNhpVqKlDcL763cmDsnXGYuQ/bNiBRntSTWCu+7jWzj/G1JG0MMqCiU5mq2eBZ0GoosHEpImHeFsGczUZXKcRuA0Wbn5lV/gnY3AgnipB382I=  ;
X-YMail-OSG: batMASMVM1m1yfedH27njcMdrS2x0qc8jZRIglt4IQVx07_qrrrVdiN1M1y0GgYbJqmq6wB3hy_qGvIdVxwozOiV4C0Ra8Mv9VprxGYtuYSzrgZL
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 6/6] UML - Fix hostfs style
Date: Thu, 23 Aug 2007 16:54:59 +0200
User-Agent: KMail/1.9.7
Cc: Satyam Sharma <satyam@infradead.org>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@osdl.org>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070817194342.GA8759@c2.user-mode-linux.org> <alpine.LFD.0.999.0708181924020.29105@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0708181924020.29105@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1313318.Pyyd6JArXv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708231655.00034.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1313318.Pyyd6JArXv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On sabato 18 agosto 2007, Satyam Sharma wrote:
> On Fri, 17 Aug 2007, Jeff Dike wrote:
> > Style fixes in hostfs.

> > @@ -328,17 +326,17 @@ int hostfs_readdir(struct file *file, vo
> > [...]
> > -		if(error) break;
> > +		if (error) break;
>
> 		if (error)
> 			break;
>
> > @@ -522,28 +523,28 @@ static int init_inode(struct inode *inod
> > [...]
> >  	else type =3D OS_TYPE_DIR;
>
> I wonder what's the generally accepted / followed coding style for this,
> actually. Personally I'd prefer:
>
> 	else
> 		type =3D OS_TYPE_DIR;

I strongly agree with this style; beyond style itself, one strong reason is=
=20
that joining statements hinder singlestepping through function code (it's=20
easy to run gdb on UML, and anyway kgdb exists).

Bye
=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade
Linux registered user n. 292729
http://www.user-mode-linux.org/~blaisorblade

--nextPart1313318.Pyyd6JArXv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGzZ/EqH9OHC+5NscRAu9LAJ9Kfap/sqi4QUvuyIhtj+DEnDHGdgCfbcq9
eBLRrE2+pLPdltvMN+fcbec=
=SRqk
-----END PGP SIGNATURE-----

--nextPart1313318.Pyyd6JArXv--
