Return-Path: <linux-kernel-owner+w=401wt.eu-S1752342AbXKVJih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbXKVJih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 04:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbXKVJi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 04:38:29 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:29828 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXKVJi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 04:38:27 -0500
Reply-To: Ubuntu@bugabundo.net, Ubuntu-reply@bugabundo.net,
       ubuntu-devel-discuss@lists.ubuntu.com, linux-kernel@vger.kernel.org
Organization: http://BUGabundo.net
To: ubuntu-devel-discuss@lists.ubuntu.com
Subject: Re: Is it possible to give the user the option to cancel forkbombs?
Date: Thu, 22 Nov 2007 00:05:32 +0000
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <473E815F.30900@minimum.se> <20071116213137.6efe3f9e@the-village.bc.nu> <473E9290.3040006@minimum.se>
In-Reply-To: <473E9290.3040006@minimum.se>
MIME-Version: 1.0
Message-Id: <200711220005.32569.Ubuntu@bugabundo.net>
Content-Type: multipart/signed;
  boundary="nextPart5608221.3yboGTe3yS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
From: "(=?utf-8?q?=60=60-=5F-=C2=B4=C2=B4?=) -- Fernando" 
	<ubuntu@bugabundo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5608221.3yboGTe3yS
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 17 November 2007 07:04:48 Martin Olsson wrote:
> Repro steps:
>=20
> 1. Install gutsy gibbon (or probably any ubuntu)
> 2. Start a gnome terminal
> 3. Run this command:
>=20
>     :(){ :|:& };:
>=20
> 4. Ubuntu starts to work furiously, after less than a second terminal=20
> gets flooded with "low resources" message, and within a few seconds the=20
> whole machine breaks down complete to the point where no a single pixel=20
> is updated and the mouse cannot be moved at all. It's not possible to=20
> escape to a ALT-Fn console terminal and CTRL-ALT-DEL does not work.
>=20
> Okay, so this is not as bad as winnuke.exe because it's not remote but I=
=20
> just did it on my shared hosting co and their server went down. And I=20
> mean seriously, there should be a way for a user to abort stuff that=20
> hogs resources this type of complete breakdown is NEVER acceptible. I=20
> had to power of the machine and my file system got royally screwed (long=
=20
> fsck etc).
>=20
> Some of you might say this is like the oldest trick in the book, yada=20
> yada yada...
>=20
> 		Martin

I used to see stuff like this happening on my University students test serv=
ers. Once they started doing forks inside for(;;), the server would go down.
Then they replaced the servers by vwmare machines, and now reboots are fast=
er.

But I would like to see installed by default some script like AND(Auto Nice=
 Daemon) or CpuLimit locking any and every process to a maximum of 90% afte=
r X seconds. That way one could allways launch a new command and kill it.
Of course, this is assuming that disk I/O is not our main prob, 'cause if t=
hat happens there's no way out.

=2D-=20
BUGabundo  :o)
(``-_-=C2=B4=C2=B4)	http://Ubuntu.BUGabundo.net
Linux user #443786    GPG key 1024D/A1784EBB
My new micro-blog @ http://BUGabundo.net

--nextPart5608221.3yboGTe3yS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHRMfMY5ijS6F4TrsRAqAzAJ0bIMMalsKPVnwXDjAlr5+45YYOpQCcDtzj
KJvA856FPgRK7A7p9d0ZFR8=
=2G+0
-----END PGP SIGNATURE-----

--nextPart5608221.3yboGTe3yS--
