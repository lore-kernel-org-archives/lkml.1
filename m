Return-Path: <linux-kernel-owner+w=401wt.eu-S932094AbYB1Ph7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbYB1Ph7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbYB1Phw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:37:52 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60835 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbYB1Phv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:37:51 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: linux-v2.6.25-rc3 issue: nvidiafb: cannot ioremap FB base
In-Reply-To: Your message of "Thu, 28 Feb 2008 15:07:27 +0100."
             <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <38b2ab8a0802280607h46a89f04wdd190a7c87571668@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204213070_3311P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Feb 2008 10:37:50 -0500
Message-ID: <22886.1204213070@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204213070_3311P
Content-Type: text/plain; charset=us-ascii

On Thu, 28 Feb 2008 15:07:27 +0100, Francis Moreau said:
> Hi,
> 
> I gave to the latest -rc (rc3) a test and it appears to fail to load the
> nvidiafb module and the reason given is:
> 
> nvidiafb: cannot ioremap FB base
> 
> Does anybody have a clue ?

Umm.. do you also have vesafb or other FB built as a module?  I got bit by
that with the binary NVidia driver, discovered it was because vesafb had
already done an ioremap of the space, but with different caching flags...

--==_Exmh_1204213070_3311P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHxtVNcC3lWbTT17ARArTJAJ9uRcF+rtEBDg6/OhKIA/PfyX9CqwCeKmRz
xvYmUoVOuV6KQDGtFIz4I2Y=
=KnwD
-----END PGP SIGNATURE-----

--==_Exmh_1204213070_3311P--
