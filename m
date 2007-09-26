Return-Path: <linux-kernel-owner+w=401wt.eu-S1761261AbXIZPnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261AbXIZPnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbXIZPmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:42:51 -0400
Received: from hu-out-0506.google.com ([72.14.214.238]:34886 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbXIZPmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:42:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:message-id;
        b=gUgpzgupofCYR/ZvIEcDbZyVt5H0M3/acyN+0GU48t8sbY+252gnPxPN/AmtYrhvlm0TslHi4ipD5+f6KSSfGzx0XDG+xQv7m4lcg0bg6pbPxtQ5qDxGVXFZp1sxVmT16Mm89ww9cldMslGoBLo8B+LX+RBYoHimbMYshotLzxo=
From: Paolo Giarrusso <p.giarrusso@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - Fix irqstack crash
Date: Wed, 26 Sep 2007 17:42:32 +0200
User-Agent: KMail/1.9.7
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070918233336.GA9746@c2.user-mode-linux.org> <200709201757.56298.p.giarrusso@gmail.com> <20070924200127.GB25202@c2.user-mode-linux.org>
In-Reply-To: <20070924200127.GB25202@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1380752.XAKfpcfMdN";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709261742.44100.p.giarrusso@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1380752.XAKfpcfMdN
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On luned=EC 24 settembre 2007, Jeff Dike wrote:
> On Thu, Sep 20, 2007 at 05:57:49PM +0200, Paolo Giarrusso wrote:
> > Yes, indeed - or sign extension on 64bit machines would set to 1 the
> > whole high-word.
> >
> > But using long for that mask makes no difference; either int or long
> > long (or  better, either u32 or u64) should be used, given that the
> > used signal range  is the same on 32 and 64bit machines, it should
> > be u32 for normal signals or u64 if RT-signals are also allowed.
>
> We don't use RT signals for anything, so we could use u32.
I wasn't sure of that.
> I don't=20
> see it making much difference though.
Agreed - the only difference is for cleanliness and easy verification.
=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade

--nextPart1380752.XAKfpcfMdN
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG+n30qH9OHC+5NscRAryQAJ9qwNwlriYOppUxyYGtZM+mXSppawCcCtQT
FbuRtB9QDFCUmLsAVMOVOT8=
=EPXm
-----END PGP SIGNATURE-----

--nextPart1380752.XAKfpcfMdN--
