Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYBHV0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYBHV0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752755AbYBHV0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:26:11 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:49919 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbYBHV0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:26:09 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] stub out is_swap_pte for !MMU
Date: Fri, 8 Feb 2008 16:25:12 -0500
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1202500959-2727-1-git-send-email-vapier@gentoo.org> <1202503750.17934.639.camel@cinder.waste.org>
In-Reply-To: <1202503750.17934.639.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1379366.Bhr3NKgpIa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802081625.12893.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1379366.Bhr3NKgpIa
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 08 February 2008, Matt Mackall wrote:
> On Fri, 2008-02-08 at 15:02 -0500, Mike Frysinger wrote:
> > With commit 698dd4ba6b12e34e1e432c944c01478c0b2cd773, swap_pte() was
> > moved into view of both MMU and !MMU, but uses functions only provided =
by
> > MMU. Here we stub out the function for !MMU ports.
>
> I'm not sure if this is right compared to my original patch. Does it
> ever make sense to ask "is this pte a swap entry?" on a machine with no
> MMU? Presumably this also means it has no ptes too, right? In which
> case, it's better to comment the whole function out. Then when someone
> tries to ask the above meaningless question, they get a compile error
> rather than a meaningless answer.

honestly, doesnt matter to me since none of the code that currently utilize=
s=20
this function is used in no-mmu context.  if you want to just put the whole=
=20
thing in CONFIG_MMU, then go for it.
=2Dmike

--nextPart1379366.Bhr3NKgpIa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR6zIuEFjO5/oN/WBAQLp7RAAvzJ88c/D6AnDqmJvm4/XiZGULcumLQZW
MntCRhdMcxv8fNYYStVJICJLzVhdcdyXUJOPULsIW74Kbn7W8Vi7zq7ByJNtgZPz
GJOC2TnMjboAJg4OG1yIFXCEwaqB4QNz0Px5tIseISTJwmLWONahhfzBRly6WPHj
fJsR+kpj2kklCdw5mLq+ws8ndWopwlH5GLXFiQs9pVlxKbuR1iXRj5CCVcvgfW/2
17auV0BoJ3U3bkMsEmfF1rA0UTS1u2E47yTgtp1OV1xTHGkkN/8kH7QzPjZaK9aP
0wwjCbNwDCxVjEjePlM+rHesI5SH9YI/5nOHAu36AxmchkXIKJbVTGRHLUiilOJG
xcGcwayGEwM84XmEDP0yit3tWUFkke/7m4z4KQO4lCJuTSvZVoGqOwUnGqJeG9D/
0z0un4Y8xAoGeCPtQbjAPhvcF0oSlbtRynwfjiGBsB+fx2XdXe79cgUaGQvAtTWU
/n4knNDsTFvdHm3kUfmyPpbno1x0WF67lWuyjc9nRJ5wmrvBeP8KTEzf4ZywjZ1y
VsxA/wt8E2RY+6PbFfKoWZlMEuSfRJ7xyHVyGesDc6C1Ib/miKhcNC3LCpWNN5E6
ALjXXDMLmDaLDYqhvRB+cn1s2990rYkVx5ZIilfMfquDMrGUkjCCkvR4D9Wudt6M
UWuz3mdWQvs=
=6v4v
-----END PGP SIGNATURE-----

--nextPart1379366.Bhr3NKgpIa--
