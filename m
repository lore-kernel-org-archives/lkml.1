Return-Path: <linux-kernel-owner+w=401wt.eu-S1757303AbYKUSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303AbYKUSM4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442AbYKUSMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:12:48 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51120 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbYKUSMr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:12:47 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: Random freeze (Re: mmotm 2008-11-19-02-19 uploaded)
In-Reply-To: Your message of "Thu, 20 Nov 2008 15:20:54 PST."
             <20081120152054.2f757251.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200811200609.mAK69ZbZ053438@www262.sakura.ne.jp> <4401.1227222347@turing-police.cc.vt.edu>
            <20081120152054.2f757251.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227291159_3137P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Nov 2008 13:12:39 -0500
Message-ID: <5672.1227291159@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227291159_3137P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Nov 2008 15:20:54 PST, Andrew Morton said:

> It's also of course possible (but less common) that someone mucked up
> the VFS.  It would be interesting to revert
> do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch.

Reverted that one, managed to provoke a wedge-up this morning anyhow.
So it's something else.

I may have to go and find a reproducer good enough to make bisection plausible.

--==_Exmh_1227291159_3137P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJJvoXcC3lWbTT17ARAqLfAJ92uA3KE5lzsW7MqvjhjF8Y8DbicACeIL4s
dW46Vnnb/dNBi9tQZyJrHws=
=scUe
-----END PGP SIGNATURE-----

--==_Exmh_1227291159_3137P--
