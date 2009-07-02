Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZGBPOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZGBPOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 11:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZGBPOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 11:14:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52110 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZGBPOb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 11:14:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
In-Reply-To: Your message of "Tue, 30 Jun 2009 13:38:16 PDT."
             <20090630133816.f62b0cb4.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <54770.1246392952@turing-police.cc.vt.edu> <56465.1246393621@turing-police.cc.vt.edu>
            <20090630133816.f62b0cb4.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246542687_46508P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jul 2009 09:51:27 -0400
Message-ID: <65196.1246542687@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246542687_46508P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 13:38:16 PDT, Andrew Morton said:
> On Tue, 30 Jun 2009 16:27:01 -0400
> Valdis.Kletnieks@vt.edu wrote:
> 
> > Not sure why that line did it.  Repeated truncate-and-try shows that if the
> > line contained just the 4 chars '0804', it applied fine, but '0804a' dies.
> 
> That's patch(1) thinking it's a regular diff:
> 
> akpm:/usr/src/25> diff Makefile Makefile~linux-next
> 4c4
...
> So the "0804a" means "at line 804, start appending stuff", or something
> like that.
> 
> Use -u.

Yep, that was it, thanks.  Added to .quiltrc.

--==_Exmh_1246542687_46508P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKTLtfcC3lWbTT17ARAoVZAKCBP0d9kZkFoxu6NP7IW+Ish8fDkwCg7Aha
SpYYoofqBM5lGzBNz9pg5Dk=
=D0Uz
-----END PGP SIGNATURE-----

--==_Exmh_1246542687_46508P--
