Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbXISPxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbXISPxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760029AbXISPxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:53:36 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53384 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637AbXISPxf (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:53:35 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1 - Mostly working, with a kbuild oddity
In-Reply-To: Your message of "Wed, 19 Sep 2007 09:34:02 +0200."
             <20070919073402.GA32218@uranus.ravnborg.org>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <7319.1190143977@turing-police.cc.vt.edu> <20070918203239.GB27836@uranus.ravnborg.org> <15592.1190153008@turing-police.cc.vt.edu>
            <20070919073402.GA32218@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190217203_23458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 11:53:23 -0400
Message-ID: <28616.1190217203@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190217203_23458P
Content-Type: text/plain; charset=us-ascii

On Wed, 19 Sep 2007 09:34:02 +0200, Sam Ravnborg said:

> > I had a few issues with some other modules, but they're evil binaries so
> > I'm taking those up directly with the companies involved.. ;)
> 
> How annoying is this - and is this the CFLAGS thing again?

The other issues were VMWare and the removal of EXPORT_SYMBOL(set_dumpable),
and NVidia graphics driver not playing nice with x86_64-mm-cpa-clflush.patch
(these actually broke back around -rc[34]-mm1, so it's not a new issue).  I
just had to spend 5 minutes re-checking that my workarounds did/didn't need
refreshing.  Like I said, their problems (and mine), not lkml's.

> We could introduce some workaraound so we continue to respect
> the CFLAGS settings in a Makefile for a while.
> But at the end of the day we should convince the external module people
> to follow the Kbuild docs. So it will then be temporary.

I already sent the author a patch for the broken Makefile.  I don't think an
in-tree workaround is the right thing here.  I've vote for an entry in the
"What's new in 2.6.2X" document when the kbuild changes go mainline, since
fixing it to use EXTRA_CFLAGS worked perfectly.  External module maintainers
have (presumably) already read stable-API-nonsense, and should be used to
fixing code for new releases, so a 1 or 2 line Makefile tweak shouldn't be a
hardship.


--==_Exmh_1190217203_23458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFG8UXzcC3lWbTT17ARAkh9AJUWLAEQG0IQpZEXQyZLkpZVXqjJAJ4th+yD
QCdYQ3vduESLEtIEtZUA0w==
=eFqL
-----END PGP SIGNATURE-----

--==_Exmh_1190217203_23458P--
