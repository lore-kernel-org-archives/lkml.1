Return-Path: <linux-kernel-owner+w=401wt.eu-S1761423AbXHHWNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761423AbXHHWNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 18:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXHHWNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 18:13:12 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55851 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbXHHWNL (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 18:13:11 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 2/3] UIO: Documentation
In-Reply-To: Your message of "Wed, 08 Aug 2007 23:36:00 +0200."
             <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070718232332.GA4620@kroah.com> <11848012053678-git-send-email-gregkh@suse.de> <11848012122374-git-send-email-gregkh@suse.de>
            <9a8748490708081436g23c8f01cga585d6612b380f16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1186611154_11818P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 08 Aug 2007 18:12:34 -0400
Message-ID: <14166.1186611154@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1186611154_11818P
Content-Type: text/plain; charset=us-ascii

On Wed, 08 Aug 2007 23:36:00 +0200, Jesper Juhl said:

> Do we really want this?
> 
> In my oppinion we run the risk here of encouraging behaviour akin to
> what NVidia is doing - release a small kernel "glue" module and then
> keep the driver proper in a binary blob (in userspace, but still a
> binary blob).
> If the company goes out of business and take their driver source with
> them then users are left with a useless, un-debugable, un-maintainable
> binary blob.
> Don't we instead want to encourage/pressure people to release specs
> and/or source code for their hardware/drivers so open, modifiable
> drivers can be written?
> 
> This opens the door for people to start writing closed drivers. In the
> long run that seems to me like a bad deal for our users.

On the other hand, given that we've always said that closed-source stuff in
userspace is OK, the only way to not let *that* horse out of the barn is to
not merge UIO at all.

If you have UIO in the kernel talking to stuff in userspace, you're going to
have to deal with closed-source stuff at the userspace end of the pipe.

Unless somebody can come up with some great feat of sophistry to avoid that?

--==_Exmh_1186611154_11818P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGuj/ScC3lWbTT17ARAvevAJ9hB9/kknf/5msY5dY6vg/UoKkGtgCgxNqa
w1pTUQ/hlBCUNuxyWsrzVS4=
=4AeJ
-----END PGP SIGNATURE-----

--==_Exmh_1186611154_11818P--
