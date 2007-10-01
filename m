Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbXJARMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbXJARMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXJARMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:12:15 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55402 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbXJARMP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:12:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm2
In-Reply-To: Your message of "Sun, 30 Sep 2007 22:01:43 +0200."
             <200709302201.44146.rjw@sisk.pl>
From: Valdis.Kletnieks@vt.edu
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org> <18268.1191119181@turing-police.cc.vt.edu> <20070930015014.78bb88d3.akpm@linux-foundation.org>
            <200709302201.44146.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191258721_3768P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 01 Oct 2007 13:12:01 -0400
Message-ID: <4202.1191258721@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191258721_3768P
Content-Type: text/plain; charset=us-ascii

On Sun, 30 Sep 2007 22:01:43 +0200, "Rafael J. Wysocki" said:
> On Sunday, 30 September 2007 10:50, Andrew Morton wrote:
> > On Sat, 29 Sep 2007 22:26:21 -0400 Valdis.Kletnieks@vt.edu wrote:
> > 
> > > On Thu, 27 Sep 2007 02:22:20 PDT, Andrew Morton said:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc8/2.6.23-rc8-mm2/
> > > 
> > > Locks up hard at very early boot on my Dell Latitude - grub says loading
> > > kernel, the screen clears, and we lock up before we get penguins.
> > > 
> > > -rc8-mm1 was OK. I'm off to go bisect, figured I'd drop a heads-up.
> > > 
> > 
> > It doesn't ring a bell, sorry.  hpet-force-enable-on-ich34.patch is known
> > to be bad, but it causes failure later in the boot than that.
> 
> http://lkml.org/lkml/2007/9/27/322, perhaps?

Yep, that was it - I applied that one patch on top of -rc8-mm2 and it
came up without complaint.  That was certainly one that would make the CPU head
off into the weeds very early in boot.

I need to figure how how I managed to botch the git bisect - it flagged the
very last commit, when the problem was commit N-1.



--==_Exmh_1191258721_3768P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHASphcC3lWbTT17ARAq2AAJ4rrS1MUs2yQNVR5HquGXHyusxWDwCg21dV
98/lFazunadroQtsQP9mMX8=
=kSXJ
-----END PGP SIGNATURE-----

--==_Exmh_1191258721_3768P--
