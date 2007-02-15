Return-Path: <linux-kernel-owner+w=401wt.eu-S1161237AbXBOU4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161237AbXBOU4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161240AbXBOU4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:56:14 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53319 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161237AbXBOU4N (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:56:13 -0500
X-Greylist: delayed 1495 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 15:56:13 EST
Message-Id: <200702152055.l1FKtfTY012824@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Dave Jones <davej@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       herbert.xu@redhat.com, linux-kernel@vger.kernel.org,
       arjan@infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/6] MODSIGN: Kernel module signing
In-Reply-To: Your message of "Wed, 14 Feb 2007 23:13:45 EST."
             <20070215041345.GA15654@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <20070214190938.6438.15091.stgit@warthog.cambridge.redhat.com> <20070214194112.5bec3110.akpm@linux-foundation.org>
            <20070215041345.GA15654@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1171572941_27755P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 15 Feb 2007 15:55:41 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1171572941_27755P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Feb 2007 23:13:45 EST, Dave Jones said:
> One argument in its favour is aparently Red Hat isn't the only vendor
> with something like this.  I've not investigated it, but I hear rumours
> that suse has something similar.  Having everyone using the same code
> would be a win for obvious reasons.

Another argument in its favor is that it actually allows the kernel to
implement *real* checking of module licenses and trumps all the proposals
to deal with MODULE_LICENSE("GPL\0Haha!").  A vendor (or user) that wants
to be *sure* that only *really really* GPL modules are loaded can simply
refuse to load unsigned modules - and then refuse to sign a module until
after they had themselves visited the source's website, verified that the
source code was available under GPL, and so on.

Remember - the GPL is about the availability of the source.  And at modprobe
time, the source isn't available.  So you're left with two options:

1) Trust the binary to not lie to you about its license.
2) Ask a trusted 3rd party (usually, the person/distro that built the kernel)
whether they've verified the claim that it's really GPL.


--==_Exmh_1171572941_27755P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF1MjNcC3lWbTT17ARAr2YAJ4wbVlqnW/LJ45a1duVb1reqCfxpwCfRuON
5sTJnmksg4ZJZQHW9qwqQDg=
=ybHd
-----END PGP SIGNATURE-----

--==_Exmh_1171572941_27755P--
