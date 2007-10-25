Return-Path: <linux-kernel-owner+w=401wt.eu-S1760788AbXJYL4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbXJYL4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 07:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756375AbXJYL43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 07:56:29 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:60925 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbXJYL42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 07:56:28 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: "James Ausmus" <james.ausmus@gmail.com>
Subject: Re: Possible 2.6.23 regression - Disappearing disk space
Date: Thu, 25 Oct 2007 13:56:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel <linux-kernel@vger.kernel.org>
References: <b79f23070710241105n725e7a9dh78bb3747adc44437@mail.gmail.com>
In-Reply-To: <b79f23070710241105n725e7a9dh78bb3747adc44437@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1864658.8YRK5pHrji";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710251356.22639.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1864658.8YRK5pHrji
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

James Ausmus wrote:
> Since updating my laptop to 2.6.23, occasionally all of my free disk
> space on my root partition will just go away, with no files accounting
> for the space, with no odd messages in dmesg or my syslog. If I
> reboot, I immediately have the proper amount of free space again. Here
> is the output of a du -sx * on /, and the output of the df command
> when the problem is occuring, followed by the same info after a fresh
> reboot (literally just did the command in the failed state, then
> immediately rebooted and ran the same commands again) - any thoughts
> as to what might be happening?

The file that eats up the memory is still opened by a process, but deleted.

HTH

Eike

--nextPart1864658.8YRK5pHrji
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHIIRmXKSJPmm5/E4RAleoAJ9rSCIblYchGOX3yKhNMdWQOLeBXgCfWbIi
Vzh3S9AYH+FqSRKNQZEnnCY=
=Z9R6
-----END PGP SIGNATURE-----

--nextPart1864658.8YRK5pHrji--
