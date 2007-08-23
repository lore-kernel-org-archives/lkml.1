Return-Path: <linux-kernel-owner+w=401wt.eu-S1764609AbXHWOu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764609AbXHWOu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762147AbXHWOus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:50:48 -0400
Received: from smtp007.mail.ukl.yahoo.com ([217.12.11.96]:22476 "HELO
	smtp007.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762117AbXHWOur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:50:47 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=GVqOsaaL4VfDIxZ0QUHaLKBsXnKGh1AVlQKdga+mFjbYVUi+iA1ClV3ZWW5N+8BzlfEsRVKFB2TVcZ/Bi0ZiHMz6DOajHuwdeJYxg7Dc1rgORrgB+5GzCbrsv0aNp+TyX31O3j0WVmolcASRZnGSUo40A5VmLWmQyYHUy7ipask=  ;
X-YMail-OSG: bcrowGkVM1kF1xcfmHJ4ABZPk_hWWedSs8AjuLu1kl3WXe7hGF0o977YJ1k6bzcEzvWZVBFzJsDpjxdfydkgrmetQovRo2XnGJ4BYP9I1fLo.eJ.
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - Add a .note.SuSE section
Date: Thu, 23 Aug 2007 16:50:37 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Dike <jdike@addtoit.com>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070816162428.GA8128@c2.user-mode-linux.org> <200708211905.59128.blaisorblade@yahoo.it> <20070822163729.GB11022@c2.user-mode-linux.org>
In-Reply-To: <20070822163729.GB11022@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1265005.ROOJuV1bcG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708231650.44468.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1265005.ROOJuV1bcG
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On mercoled=EC 22 agosto 2007, Jeff Dike wrote:
> On Tue, Aug 21, 2007 at 07:05:53PM +0200, Blaisorblade wrote:
> > It's not the first time we hit effects of such bugs, is it?
>
> I don't remember seeing this before.
>
> > The .note.ABI-tag fix, time ago, may be about the same problem.
>
> Are you referring to
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdi
>ff;h=3Dc35e584c087381aaa5f1ed40a28b978535c18fb2;hp=3Da5bd1786fb30abe663b90=
4f6d79
>bba413e9ba883?

Yes.

>If so, I never understood that - it just came in saying "this=20
> fixes static building", so I sent it along.

In this case, I'm referring to the patch which had a typo, which is yours:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3D7632fc8f809a97f9d82ce125e8e3e579390ce2e5
Description follows:
"During a static link, ld has started putting a .note section in the
=2Euml.setup.init section.  This has the result that the UML setups begin
with 32 bytes of garbage and UML crashes immediately on boot.

This patch creates a specific .note section for ld to drop this stuff
into."

My patch only made your change work for real - IIRC you had fixed that exac=
t=20
typo too, but you forgot to run quilt refresh before sending the patch (btw=
,=20
quilt pop -a will force you to refresh all patches to succeed - I do it=20
frequently).

> BTW, that commit was singled=20
> out by git-bisect as "causing" this particular problem.
>
> > Can you
> > double-check all UML linker scripts for more instances of this bug?
>
> I did, I have a patch, and it's been verified to fix the problem.

In this case, we _may_ want to remove the .note section altogether - even i=
f=20
it is likely to shake out more problems.

Good bye!
=2D-=20
"Doh!" (cit.), I've made another another mistake!
Paolo Giarrusso, aka Blaisorblade
Linux registered user n. 292729
http://www.user-mode-linux.org/~blaisorblade

--nextPart1265005.ROOJuV1bcG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGzZ7EqH9OHC+5NscRAiMCAJ4pMb6fCpv5EtsGQ06YNewWYyD1/QCgildc
wzUSddXHnjiZfhiqr28ycK4=
=V6aQ
-----END PGP SIGNATURE-----

--nextPart1265005.ROOJuV1bcG--
