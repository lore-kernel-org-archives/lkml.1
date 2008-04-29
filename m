Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbYD2JNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbYD2JNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYD2JNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:13:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:14443 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYD2JNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:references:in-reply-to:cc:mime-version:content-type:content-transfer-encoding:message-id;
        b=mwgUyjGa71iF0w85T0jRFv7b61vtmVcw/+8mtdLlRbImlpQWKr+S5orrqdwBEcbNkumQr5pdsAHJrA8+K4N0w8/EF6s/fOhdoQZ/WdlCjBNRU9puS1fE2RKSg37tFROe9KOQDI8/VZrdmMp7Vr/akgurhQ/Zrd3gZqKxwndcLFE=
From: Daniel Klaffenbach <danielklaffenbach@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [2.6.25-stable PATCH] regression: powertop says 120K wakeups/sec
Date: Tue, 29 Apr 2008 11:14:08 +0200
User-Agent: KMail/1.9.9
References: <200804242015.19462.lenb@kernel.org> <200804282001.06680.danielklaffenbach@gmail.com> <924EFEDD5F540B4284297C4DC59F3DEEF31967@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEF31967@orsmsx423.amr.corp.intel.com>
Cc: "Len Brown" <lenb@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1508588.lF1xQnLCNZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804291114.14890.danielklaffenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1508588.lF1xQnLCNZ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Pallipadi, Venkatesh wrote:
> With git11+wakeup patch, things seems to be working fine as per
>
> >http://www-user.tu-chemnitz.de/~klada/misc/kernel/cpuidle_git11_wakeupp
>
> atch.txt
>
> CPU is spending most of the time in C3 state. Looks like there is some
> problem with
> powertop reporting here. I know there were some changes to this area in
> powertop.
> Can you try the latest powertop version from svn
> (http://www.lesswatts.org/projects/powertop/download.php) and see
> whether the issue is fixed.
>
> Thanks,
> Venki
You are right, with powertop-svn C2-usage is being displayed properly. I ho=
pe=20
your patch is going to make it to the stable tree pretty soon.

Thank you,
Daniel

--nextPart1508588.lF1xQnLCNZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBIFubmM8RD99ZskA8RApaZAKDCv5RKiYjMbO1JqmeLfdpavyrNiACguylN
wi7NiH7/R3dem8/Wc8Y/rJk=
=OyA2
-----END PGP SIGNATURE-----

--nextPart1508588.lF1xQnLCNZ--
