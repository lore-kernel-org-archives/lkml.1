Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbYKZTgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbYKZTgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYKZTfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:35:55 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49736 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbYKZTfz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:35:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jan Kara <jack@suse.cz>
Cc: mfasheh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc6-mmotm1126 - BUG in disk quota code
In-Reply-To: Your message of "Wed, 26 Nov 2008 18:58:11 +0100."
             <20081126175811.GH23124@duck.suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <4270.1227716433@turing-police.cc.vt.edu> <20081126164906.GG23124@duck.suse.cz> <3893.1227721813@turing-police.cc.vt.edu>
            <20081126175811.GH23124@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1227728116_4046P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Nov 2008 14:35:16 -0500
Message-ID: <4235.1227728116@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1227728116_4046P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Nov 2008 18:58:11 +0100, Jan Kara said:

> > Good enough - I'll wait for Andrew to drop the next -mmotm, and I'll
> > yell if it's still broken then...
>   Hmm, I've just checked and it does not seem Mark has merged the patches
> yet. I've attached the patches which fix the problem just in case you need
> to boot the machine with -mm for some other purposes.

Confirming the 4 patches fixed the BUG in quotaon.  Still need to track down
the ACPI bug I'm hitting...

--==_Exmh_1227728116_4046P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJLaT0cC3lWbTT17ARAhV6AKCbCSPKplnh11BzR8wrCIyeIet5SACfWNlZ
ea8K428rYylieh7IBgxSP6k=
=N3ep
-----END PGP SIGNATURE-----

--==_Exmh_1227728116_4046P--
