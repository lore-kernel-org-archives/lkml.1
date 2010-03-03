Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab0CCXfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:35:06 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:55408 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0CCXe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:34:58 -0500
From: Eric Anholt <eric@anholt.net>
To: Surbhi Palande <surbhi.palande@canonical.com>,
       dri-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie, yakui.zhao@intel.com,
       jbarnes@virtuousgeek.org, airlied@redhat.com, zhenyuw@linux.intel.com
Subject: Re: [PATCH] drm/i915: blacklist lid status: Sony VGN-BX196VP, Dell
 Inspiron 700m
In-Reply-To: <1267563592-6614-1-git-send-email-surbhi.palande@canonical.com>
References: <1267563592-6614-1-git-send-email-surbhi.palande@canonical.com>
Date: Wed, 03 Mar 2010 15:34:52 -0800
Message-ID: <87lje9ou77.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue,  2 Mar 2010 22:59:52 +0200, Surbhi Palande <surbhi.palande@canonica=
l.com> wrote:
> BugLink: https://bugs.launchpad.net/bugs/515246
>=20
> Sony VGN-BX196VP and Dell Inspiron 700m report lid status as closed
> when it is open. This leads to a "no connectors reported" error at startu=
p.
> Blacklisting them, to always return a connected status for the default
> lvds connector.
>=20
> Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>

As far as I know, this should already be covered by:

commit 7b9c5abee98c54f85bcc04bd4d7ec8d5094c73f4
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Feb 12 09:30:00 2010 -0800

    drm/i915: give up on 8xx lid status

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuO8h0ACgkQHUdvYGzw6vecfgCfWcY47iSkosSwBnWX0IVfNMg8
AHMAnjkWgQ5UwrENaiOt8wWUHEdD44YW
=6bUV
-----END PGP SIGNATURE-----
--=-=-=--
