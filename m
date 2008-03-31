Return-Path: <linux-kernel-owner+w=401wt.eu-S1757718AbYCaSWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbYCaSWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 14:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbYCaSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 14:22:10 -0400
Received: from smtp1.infomaniak.ch ([84.16.68.89]:36063 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbYCaSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 14:22:09 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?utf-8?q?2=2E6=2E25-rc7=C2=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?utf-8?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 20:22:00 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <20080331172455.GV17874@baikonur.stro.at> <200803311936.02517.didier@raboud.com>
In-Reply-To: <200803311936.02517.didier@raboud.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2645661.jKdPklJsLI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803312022.03190.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp1 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2645661.jKdPklJsLI
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le lundi, 31 mars 2008 19.36:00 Didier Raboud, vous avez =C3=A9crit=C2=A0:
> Le lundi, 31 mars 2008 19.24:55 maximilian attems, vous avez =C3=A9crit=
=C2=A0:
> > On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
> > <snipp>
> >
> > > > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successf=
ul
> > > > > hibernate/resume cycles.
> > > >
> > > > Could you please check if the problem is still present if you boot
> > > > with acpi_new_pts_ordering kernel command line argument?
> > >
> > > By the way, I just added acp_new_pts_ordering at the end of the Grub
> > > line beginning by "linux (hd0,1)/vmlinuz(...)". Is that correct=C2=A0?
> >
> > seems strange you should add it to the kopt line and then kick as root
> > update-grub
> >
> > # kopt=3Droot=3D/dev/sda1 ro
> > it should land
> > kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=3D/dev/sda1 ro
>
> Well... I'm using Grub2 (grub-pc). I altered the boot option at boot time
> but forgot to check /proc/cmdline. Will try again and report back.
>
> Regards,
>
> Didier

Hi,=20

I tried again and ensured that /proc/cmdline 's end was=20
acpi_new_pts_ordering . It did work for 2-3 hibernation, but then failed.

Regards,=20

Didier

--nextPart2645661.jKdPklJsLI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8SvLwW1nnOmiePARAp2sAJ9wDGgw+mLVauXruLTu5B45lDEddACfXo6v
89JdBnwj/FhFj9uput/QVAQ=
=xecU
-----END PGP SIGNATURE-----

--nextPart2645661.jKdPklJsLI--
