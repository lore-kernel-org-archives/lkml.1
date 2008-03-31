Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbYCaRgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbYCaRgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753144AbYCaRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:36:13 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:41023 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372AbYCaRgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:36:12 -0400
From: Didier Raboud <didier@raboud.com>
To: linux-kernel@vger.kernel.org
Subject: Re: =?iso-8859-1?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-1?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 19:36:00 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200803311903.16011.didier@raboud.com> <20080331172455.GV17874@baikonur.stro.at>
In-Reply-To: <20080331172455.GV17874@baikonur.stro.at>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1738733.5t0Tiokqkd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803311936.02517.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1738733.5t0Tiokqkd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le lundi, 31 mars 2008 19.24:55 maximilian attems, vous avez =E9crit=A0:
> On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
> <snipp>
>
> > > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful
> > > > hibernate/resume cycles.
> > >
> > > Could you please check if the problem is still present if you boot wi=
th
> > > acpi_new_pts_ordering kernel command line argument?
> >
> > By the way, I just added acp_new_pts_ordering at the end of the Grub li=
ne
> > beginning by "linux (hd0,1)/vmlinuz(...)". Is that correct=A0?
>
> seems strange you should add it to the kopt line and then kick as root
> update-grub
>
> # kopt=3Droot=3D/dev/sda1 ro
> it should land
> kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=3D/dev/sda1 ro

Well... I'm using Grub2 (grub-pc). I altered the boot option at boot time b=
ut=20
forgot to check /proc/cmdline. Will try again and report back.

Regards,=20

Didier

--nextPart1738733.5t0Tiokqkd
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8SECwW1nnOmiePARAsRSAKCOx3cNW+bzMnN23cfMGPud0A3ufwCfSnRW
ooj8dJFVoAiHEfAXkBgP4Zw=
=8LNf
-----END PGP SIGNATURE-----

--nextPart1738733.5t0Tiokqkd--
