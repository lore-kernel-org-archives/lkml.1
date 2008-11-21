Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYKUFXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYKUFXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 00:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbYKUFX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 00:23:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44570 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYKUFX1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 00:23:27 -0500
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
Content-Type: multipart/signed; boundary="==_Exmh_1227244998_3088P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Nov 2008 00:23:18 -0500
Message-ID: <5539.1227244998@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227244998_3088P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Nov 2008 15:20:54 PST, Andrew Morton said:

> The traditional cause of the above trace is that someone mucked up the
> block/driver/irq-routing layer and we lost an IO completion.

Yes, that would explain all the symptoms and tracebacks - everybody comes
to a screeching halt the next time they try to go to disk, while the actual
disk drive is showing zero activity.

> It's also of course possible (but less common) that someone mucked up
> the VFS.  It would be interesting to revert
> do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary.patch.

I'm seeing an MTBF of about 2-3 hours when actually applying an I/O load to the
system.  I'll try reverting that patch, and if it survives an entire day or
two it will be pretty strong circumstantial evidence that patch is the culprit...

--==_Exmh_1227244998_3088P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJJkXGcC3lWbTT17ARAhR+AJ9FNGGqOiW6wXpBWLqXto6+gZquGQCfZIFQ
nCXcmd0PpNh+oS0v5v5ZjNo=
=vWBc
-----END PGP SIGNATURE-----

--==_Exmh_1227244998_3088P--
