Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbZCNIIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbZCNIIy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 04:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZCNIIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 04:08:38 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:54628 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbZCNIIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 04:08:35 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29-rc breaks STD using Intel 945
Date: Sat, 14 Mar 2009 09:08:19 +0100
User-Agent: KMail/1.9.10
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200903042020.57671.eike-kernel@sf-tec.de>
In-Reply-To: <200903042020.57671.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2705138.m6vsZLayEE";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903140908.26725.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2705138.m6vsZLayEE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Rolf Eike Beer wrote:
> Hi,
>
> I tested several snapshots post 2.6.28 and all of them show one severe
> problem: resume from disk is not always successful. Only about 50% of the
> resume attempts work, in the other cases I just get a completely black
> screen, can't switch to text console or anything. What I often get is a
> line like this in the logs directly before suspend:
>
> [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for
> disabled pipe 0
>
> Afterwards I find nothing in the logs. Switching back to 2.6.28 and
> everything works fine again. I have a Toshiba A110-178 running openSuSE
> 11.1 32 bit with KDE 4.2.0. I upgraded my Xserver from 1.5 to 1.6 yesterday
> but that did not change anything. The only external module I use is the
> omnibook module (http://sf.net/projects/omnibook) which I've been using for
> years without any problems.

The problem still exists in -rc8

Greetings,

Eike

--nextPart2705138.m6vsZLayEE
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkm7ZfoACgkQXKSJPmm5/E6FMgCfdfW07x97I3tZD11INJOdBCNk
14oAoIZ6b7visykOKP6IdnD6LxJEoSvg
=2xEM
-----END PGP SIGNATURE-----

--nextPart2705138.m6vsZLayEE--
