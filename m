Return-Path: <linux-kernel-owner+w=401wt.eu-S1757048AbYHUXi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048AbYHUXi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750972AbYHUXit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:38:49 -0400
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:56480
	"EHLO tadamune.kami.home" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750788AbYHUXit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:38:49 -0400
X-Greylist: delayed 2591 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Aug 2008 19:38:49 EDT
Date: Fri, 22 Aug 2008 07:55:37 +0900
From: Mattia Dongili <malattia@linux.it>
To: Martin Filip <bugtraq@smoula.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cpufreq regression, unable to set lower frequency
Message-ID: <20080821225537.GB20165@inferi.kami.home>
References: <1219341101.9264.4.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1219341101.9264.4.camel@localhost>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.25-1 i686
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2008 at 07:51:41PM +0200, Martin Filip wrote:
> Hi LKML,
>=20
> I've upgraded my kernel few days earlier and suddenly my cpufreqd
> stopperd working. My configuration is this:
> AC adapter connected:
>   set scaling_max_freq and scaling_min_freq to maximal available
> frequency
> AC adapter disconnected:
>   set scaling_max_freq to maximal available, scaling_min_freq to minimal
> available.
>=20
> When I connect AC adapter, everything works fine but when I disconnect
> my adapter, everything remains on maximal frequency and in logs I can
> see:
>=20
> cpufreqd: cpufreqd_set_profile: Couldn't set profile "Powersave Low" set
> for cpu0
>=20
> After some tests I've traced problem to=20
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.25.y.git;a=
=3Dcommitdiff;h=3D53391fa20cab6df6b476a5a0ad6be653c9de0c46
=20
what version of cpufrequtils are running? This error should be fixed in
004 (or later) with this patch:
http://git.kernel.org/?p=3Dutils/kernel/cpufreq/cpufrequtils.git;a=3Dcommit=
;h=3Db88f8975d27690e04e520b05a1ed66bf1e306ee6

thanks
--=20
mattia
:wq!

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkit8mkACgkQgpRPaOotLEGLnwCg32TYUFrQNiNAAiqBmIJLrSIA
x28AoK7nMsiI0pWg2a/G8DN2iUiRkfS2
=LxXV
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
