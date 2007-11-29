Return-Path: <linux-kernel-owner+w=401wt.eu-S933222AbXK2U5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222AbXK2U5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760703AbXK2U5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:57:37 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50052 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979AbXK2U5h (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:57:37 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jon Masters <jonathan@jonmasters.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: Your message of "Thu, 29 Nov 2007 14:45:51 EST."
             <1196365551.6473.103.camel@perihelion>
From: Valdis.Kletnieks@vt.edu
References: <20071128183040.GW8181@ftp.linux.org.uk> <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com> <20071129173601.34273083@the-village.bc.nu> <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com> <1196362612.6473.98.camel@perihelion> <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com>
            <1196365551.6473.103.camel@perihelion>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196369788_2822P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 29 Nov 2007 15:56:28 -0500
Message-ID: <2812.1196369788@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196369788_2822P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Nov 2007 14:45:51 EST, Jon Masters said:
> Ah, but I could write a sequence of pages that on their own looked
> garbage, but in reality, when executed would print out a copy of the
> Jargon File in all its glory. And if you still think you could look for
> patterns, how about executable code that self-modifies in random ways
> but when executed as a whole actually has the functionality of fetchmail
> embedded within it? How would you guard against that?

So, just because Fred Cohen showed in his PhD thesis that *perfect* virus/malware
scanning is equivalent to the Turing Halting Problem, we should abandon
efforts to make a 99.9998% workable system?

Yes, most of these schemes *can* be bypassed because some malicious code does a
mmap() or similar trick. But what is being overlooked here is that in most
cases, what is *desired* is a way to filter things being handled by *non*
malicious code.  Yeah, sure, a shar archive can contain a binary that does evil
things - but if we stop /bin/cp from copying the file that has the evil in it,
it's a non-issue.

Let's get real here guys - trying to do *absolutely perfect* security is
pointless.  You want to do security that reduces your *total* cost - and in
most cases this means "pretty good security" that stops "almost all issues".

As Linus reminds us once in a while - the perfect is the enemy of the good.
In this case, we don't *need* to be perfect - we only need to be noticably
better than another well-known operating system that isn't even very good at
it.

--==_Exmh_1196369788_2822P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHTyd8cC3lWbTT17ARAqWsAKCiKs0HRChnuorAfSWxa49hPuOFcgCg/Ass
jiQaMKkqgeSLqRiLaQwf+bs=
=xxCP
-----END PGP SIGNATURE-----

--==_Exmh_1196369788_2822P--
