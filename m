Return-Path: <linux-kernel-owner+w=401wt.eu-S1161482AbXBOWOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161482AbXBOWOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161479AbXBOWOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:14:22 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44449 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161481AbXBOWOV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:14:21 -0500
Message-Id: <200702152212.l1FMCh0Z018611@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adrian Bunk <bunk@stusta.de>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
In-Reply-To: Your message of "Thu, 15 Feb 2007 22:32:40 +0100."
             <20070215213240.GG13958@stusta.de>
From: Valdis.Kletnieks@vt.edu
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org> <20070215041345.GA15654@redhat.com> <200702152055.l1FKtfTY012824@turing-police.cc.vt.edu>
            <20070215213240.GG13958@stusta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171577563_27755P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Feb 2007 17:12:43 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171577563_27755P
Content-Type: text/plain; charset=us-ascii

On Thu, 15 Feb 2007 22:32:40 +0100, Adrian Bunk said:
> There are different opinions whether the "complete source code" of the 
> GPLv2 includes in such cases public keys, making it questionable whether 
> your example will survive at court in all jurisdictions.

It's no less shaky than the whole EXPORT_SYMBOL_GPL-as-enforcement crock. :)

> E.g. remember that gpl-violations.org has already successfully enforced 
> the publication of public keys for "firmware only loads signed kernels" 
> cases by threatening companies to otherwise take legal actions in 
> Germany.

A court order for the publication of *public* keys? :)

I think you meant "private keys" in both paragraphs above.  And it's probably
a non-issue the way Red Hat implemented it - they included a document on
"How to generate your own public/private key pair", which invokes commands that
create a bitstring that you can then use to sign the entire applicable part
of the kernel tree.  The fact that it's not the *same* bitstring as they used
is (IMHO) legally about as relevant as the fact that they compiled the tree
with one release of GCC, included instructions on how to compile it, and I
don't get a bitwise identical binary if I compile it with a different GCC
release.

Yes, you're still screwed if you only build *part* of the kernel tree and
expect it to work - modules you sign won't load into their kernel, and vice
versa.  But that's the same problem as the old 2.4 "You didn't do a make clean
between rebuilds and you bugged out because different parts of the tree were
built with different GCC releases".  As distributed, you *can* build a working
kernel from the pieces and instructions provided.



--==_Exmh_1171577563_27755P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1NrbcC3lWbTT17ARArCoAJ9ICZV/weZlac6F/Ys3WarRaw0k/ACfY/py
MUizyOd65J1buuquNJagu+I=
=I4MO
-----END PGP SIGNATURE-----

--==_Exmh_1171577563_27755P--
