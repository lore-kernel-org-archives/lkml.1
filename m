Return-Path: <linux-kernel-owner+w=401wt.eu-S1423301AbXBHUFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423301AbXBHUFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423300AbXBHUFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:05:52 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:43437 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423301AbXBHUFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:05:51 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] export ufs_fs.h to userspace
Date: Thu, 8 Feb 2007 15:05:35 -0500
User-Agent: KMail/1.9.6
Cc: dushistov@mail.ru, linux-kernel@vger.kernel.org, sparc@gentoo.org
References: <200702080246.16996.vapier@gentoo.org> <20070208200216.GA5913@infradead.org>
In-Reply-To: <20070208200216.GA5913@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6757182.F05q4Jz7hl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702081505.36513.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6757182.F05q4Jz7hl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 08 February 2007, Christoph Hellwig wrote:
> On Thu, Feb 08, 2007 at 02:46:16AM -0500, Mike Frysinger wrote:
> > was ufs_fs.h purposefully not exported to userspace or did it just slip
> > through the cracks ?  assuming the latter scenario, the attached patch
> > touches up the relationship between ufs_fs.h and its sub headers (like
> > ufs_fs_sb.h) so that we can export it ... the silo bootloader takes
> > advantage of this header for example
>
> We should only export kernel interfaces and ufs_fs.h isn't one.  silo
> wants it because it defines the ufs format - but the linux structs for
> that can and do change, e.g. adding unions when we add support for the
> gazillion+1st ufs format variant.  silo should just grab a copy of it
> that it's happy with it and update it when it needs to support another
> format variant (which I think is a rather theoretical issue as silo
> only supports the solaris/sparc format IIR)

seems logical to mean, thanks for the response
-mike

--nextPart6757182.F05q4Jz7hl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iQIVAwUARcuCkEFjO5/oN/WBAQIifxAAsq+oHbGS3klpz9vikjJluKUtn/VZVoTU
a1D4gC6EG8hAy2TuAq4d7MCkh2XOBit4nsm7KzeFzyK7QYO1uK+uh2AgX5GzsOst
S5ghr0JufCfBBgfL4lAV787OyHuB8g0lst7AcEQpOVXYBvORyvH8oFXlFHVDosGp
yAIGgC6W6ERrAFGG0QmzpZbqB4CROvurHOe21g6rFuZcQMtaoB/B+d5bTNODvESX
pGn4F9gcPt+J/DuxOBiY9759idpABorfrAEVM2lCFb7r3QdG6c+h6T3kwG6rVWwN
qTAP6b2mX5JmX7SuJ3GXV4MwIzgTktHKbW6jmJaCe3zBOc56+TMkUsAYBc2hwO06
ib/6kWMePcx2wW05oY9J2E8LCTBQ8+0XmX8PQ5JRRTXsDMeVhCt7ZFYaCozaRTzR
uR0cweyFaXS6VmRtWT3Uoh1wrblsouUNZOxzyo0f+qRclrSRBSgh6rsvBX5gWG0N
pA6dTAqi+mpGgH9TlqaIVp29fg2g0x4KgshwJbZKYe+qlTsbo4rZEYu14x5HH02M
ws3Oi5Vtm+kd6kGd2C1tkLZlA9DRfwURTb+sl30hfJIyOkis6bWxM5ZIek2AGABG
8ntscirPNa36S7BG9mvPFAcHRiQabjHXay8bnJdGQ+lqehz0z2n0bRS13MH7zx2q
644s6GAJ3tA=
=o84K
-----END PGP SIGNATURE-----

--nextPart6757182.F05q4Jz7hl--
