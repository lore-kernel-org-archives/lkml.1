Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab0BDQgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:36:39 -0500
Received: from gabe.freedesktop.org ([131.252.210.177]:51222 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab0BDQgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:36:38 -0500
From: Eric Anholt <eric@anholt.net>
To: Thomas Meyer <thomas@m3y3r.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Joe Perches <joe@perches.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i915: slow acpi_lid_open() causes flickering - V2
In-Reply-To: <1265137744.2353.3.camel@localhost.localdomain>
References: <1265137744.2353.3.camel@localhost.localdomain>
Date: Thu, 04 Feb 2010 08:37:05 -0800
Message-ID: <877hqtrm8e.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

On Tue, 02 Feb 2010 20:09:04 +0100, Thomas Meyer <thomas@m3y3r.de> wrote:
> acpi_lid_open() could take up to 10ms on my computer.  Some component is
> calling the drm GETCONNECTOR ioctl many times in a row.  This results in
> flickering (for example, when starting a video).  Fix it by assuming an
> always connected lid status.

Applied.  Thanks!

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktq97EACgkQHUdvYGzw6ver+ACfdZ30gLov8I41R1Do60E2ZOqR
CEYAn0pRJMAFljdMRsRxvEU0o+UrPEtY
=3ROZ
-----END PGP SIGNATURE-----
--=-=-=--
