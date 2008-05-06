Return-Path: <linux-kernel-owner+w=401wt.eu-S1761830AbYEFSYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761830AbYEFSYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYEFSYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:24:39 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38762 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYEFSYi (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:24:38 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
       Al Viro <viro@ZenIV.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: !x & y typo in mtrr code
In-Reply-To: Your message of "Wed, 30 Apr 2008 08:35:34 PDT."
             <1209569734.24729.65.camel@brick>
From: Valdis.Kletnieks@vt.edu
References: <1209268817.14173.43.camel@brick> <20080427042051.GL5882@ZenIV.linux.org.uk> <20080429210435.GA23008@elte.hu> <20080430064603.GA3602@atjola.homenet> <20080430093233.GD23528@elte.hu> <20080430121738.GA4559@atjola.homenet> <20080430123536.GD30735@elte.hu>
            <1209569734.24729.65.camel@brick>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1210098257_3003P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 May 2008 14:24:17 -0400
Message-ID: <4368.1210098257@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1210098257_3003P
Content-Type: text/plain; charset=us-ascii

On Wed, 30 Apr 2008 08:35:34 PDT, Harvey Harrison said:
> On Wed, 2008-04-30 at 14:35 +0200, Ingo Molnar wrote:
> > We for one simply concentrate on the the things that we think makes it 
> > more likely to find bugs. For example we build and boot x86.git with 
> > many different configs before every pull request. In practice that 
> > catches far more tester-critical bugs than Sparse - and we know that 
> > simply from the fact because we use both methods and have a good 
> > comparison of the results. We also work on automating Sparse checks in 
> > the future but as i said it, it's not easy.
> > 
> 
> That's precisely why I've been sending all of the sparse cleanup patches
> lately, to try and get the output down to something more managable.  You
> may want to upgrade your sparse to one that understands __cold though.

What release of sparse would that be?  Fedora ships one tagged as 0.4.1-2.fc9,
but that says:

include/linux/kernel.h:135:52: error: attribute '__cold__': unknown attribute

But you go look at Documentation/sparse.txt and it points you to:

"You can get latest released versions from the Sparse homepage at
http://www.kernel.org/pub/linux/kernel/people/josh/sparse/ "

which says 0.4.1 is the latest released version.  So is this a git-only feature?

--==_Exmh_1210098257_3003P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIIKJQcC3lWbTT17ARAsQTAJ4ugxYPM2XF5C2Ft0+KsrWAGgmv6gCePhn4
FlZlIgViLR1v8GEtPpNAIZU=
=Li4C
-----END PGP SIGNATURE-----

--==_Exmh_1210098257_3003P--
