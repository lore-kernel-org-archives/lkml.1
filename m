Return-Path: <linux-kernel-owner+w=401wt.eu-S1762072AbZD1QCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762072AbZD1QCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbZD1QCd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:02:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:59362 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181AbZD1QCb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:02:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-24-18-14 uploaded - NVidia indigestion
In-Reply-To: Your message of "Tue, 28 Apr 2009 08:15:57 +0200."
             <20090428061557.GA29299@wotan.suse.de>
From: Valdis.Kletnieks@vt.edu
References: <200904250133.n3P1XBJn006790@imap1.linux-foundation.org> <5622.1240628800@turing-police.cc.vt.edu> <20090425052434.GE10088@wotan.suse.de> <57773.1240857915@turing-police.cc.vt.edu>
            <20090428061557.GA29299@wotan.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1240934480_4310P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Apr 2009 12:01:21 -0400
Message-ID: <20954.1240934481@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1240934480_4310P
Content-Type: text/plain; charset=us-ascii

On Tue, 28 Apr 2009 08:15:57 +0200, Nick Piggin said:

Here's the code (pretty much *all* the code):

> #include <linux/version.h>
> #include <linux/utsname.h>
> int main() {
> 	if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)) {
> 		return 0;
> 	} else {
> 		return 1;
> 	}
> }

> Hmm, yes if you build without -O, then it appears like the compiler
> trips over this. I wouldn't be unhappy with just removing the BUILD_BUG_ON,
> but shouldn't the module be using -O[s2]?

It's a little autoconfig chunk from vendor code that determines if we're
building on a sane/recent kernel.  Not the sort of thing you'd expect to
need to invoke the frikking optimizer for program *correctness* :)



--==_Exmh_1240934480_4310P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ9yhQcC3lWbTT17ARAp4pAJ9lmNwbL7k1NuxNUY+iibD86F8MdQCdFbKN
vjn1KypPeMRZhYtw8F0C+Vc=
=aqix
-----END PGP SIGNATURE-----

--==_Exmh_1240934480_4310P--
