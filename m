Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYCaVDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYCaVDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbYCaVDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:03:43 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:38254 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbYCaVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:03:42 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 23:03:16 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200803312022.03190.didier@raboud.com> <200803312229.20712.rjw@sisk.pl>
In-Reply-To: <200803312229.20712.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1424547.I9XFfdlVNo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803312303.19623.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1424547.I9XFfdlVNo
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le lundi, 31 mars 2008 22.29:20 Rafael J. Wysocki, vous avez =E9crit=A0:
> On Monday, 31 of March 2008, Didier Raboud wrote:
> > Le lundi, 31 mars 2008 19.36:00 Didier Raboud, vous avez =E9crit=A0:
> > > Le lundi, 31 mars 2008 19.24:55 maximilian attems, vous avez =E9crit=
=A0:
> > > > On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
> > > > <snipp>
> > > >
> > > > > > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two
> > > > > > > successful hibernate/resume cycles.
> > > > > >
> > > > > > Could you please check if the problem is still present if you
> > > > > > boot with acpi_new_pts_ordering kernel command line argument?
> > > > >
> > > > > By the way, I just added acp_new_pts_ordering at the end of the
> > > > > Grub line beginning by "linux (hd0,1)/vmlinuz(...)". Is that
> > > > > correct=A0?
> > > >
> > > > seems strange you should add it to the kopt line and then kick as
> > > > root update-grub
> > > >
> > > > # kopt=3Droot=3D/dev/sda1 ro
> > > > it should land
> > > > kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=3D/dev/sda1 ro
> > >
> > > Well... I'm using Grub2 (grub-pc). I altered the boot option at boot
> > > time but forgot to check /proc/cmdline. Will try again and report bac=
k.
> > >
> > > Regards,
> > >
> > > Didier
> >
> > Hi,
> >
> > I tried again and ensured that /proc/cmdline 's end was
> > acpi_new_pts_ordering . It did work for 2-3 hibernation, but then faile=
d.
>
> Well, there were quite a lot of suspend-related changes between 2.6.24 and
> now.
>
> Hmm, do you have CONFIG_USB_SUSPEND set in .config by chance?
>
> Rafael

I do (Debian default option)... I will build a kernel without it and retry.=
=20

Didier

--nextPart1424547.I9XFfdlVNo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8VGXwW1nnOmiePARAvtQAJ0SXHnrj/7CDDM8CSrkXTM9fQ07fQCdGKBr
EKjzSHakgRchUE/aq7xr8Tg=
=CTK7
-----END PGP SIGNATURE-----

--nextPart1424547.I9XFfdlVNo--
