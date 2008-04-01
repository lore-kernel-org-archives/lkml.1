Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYDAJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYDAJjS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbYDAJjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:39:06 -0400
Received: from smtp1.infomaniak.ch ([84.16.68.89]:32840 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbYDAJjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:39:05 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?utf-8?q?2=2E6=2E25-rc7=C2=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?utf-8?q?_Dell_Latitude?= D630
Date: Tue, 1 Apr 2008 08:41:43 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200803312303.19623.didier@raboud.com> <200804010818.59269.didier@raboud.com>
In-Reply-To: <200804010818.59269.didier@raboud.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1588300.hqSSEA4Kmh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804010841.45623.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp1 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1588300.hqSSEA4Kmh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le mardi, 1 avril 2008 08.18:57 Didier Raboud, vous avez =C3=A9crit=C2=A0:
> Le lundi, 31 mars 2008 23.03:16 Didier Raboud, vous avez =C3=A9crit=C2=A0:
> > Le lundi, 31 mars 2008 22.29:20 Rafael J. Wysocki, vous avez =C3=A9crit=
=C2=A0:
> > > On Monday, 31 of March 2008, Didier Raboud wrote:
> > > > Le lundi, 31 mars 2008 19.36:00 Didier Raboud, vous avez =C3=A9crit=
=C2=A0:
> > > > > Le lundi, 31 mars 2008 19.24:55 maximilian attems, vous avez =C3=
=A9crit=C2=A0:
> > > > > > On Mon, Mar 31, 2008 at 07:03:13PM +0200, Didier Raboud wrote:
> > > > > > <snipp>
> > > > > >
> > > > > > > > > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two
> > > > > > > > > successful hibernate/resume cycles.
> > > > > > > >
> > > > > > > > Could you please check if the problem is still present if y=
ou
> > > > > > > > boot with acpi_new_pts_ordering kernel command line argumen=
t?
> > > > > > >
> > > > > > > By the way, I just added acp_new_pts_ordering at the end of t=
he
> > > > > > > Grub line beginning by "linux (hd0,1)/vmlinuz(...)". Is that
> > > > > > > correct=C2=A0?
> > > > > >
> > > > > > seems strange you should add it to the kopt line and then kick =
as
> > > > > > root update-grub
> > > > > >
> > > > > > # kopt=3Droot=3D/dev/sda1 ro
> > > > > > it should land
> > > > > > kernel          /boot/vmlinuz-2.6.25-rc7-amd64 root=3D/dev/sda1=
 ro
> > > > >
> > > > > Well... I'm using Grub2 (grub-pc). I altered the boot option at
> > > > > boot time but forgot to check /proc/cmdline. Will try again and
> > > > > report back.
> > > > >
> > > > > Regards,
> > > > >
> > > > > Didier
> > > >
> > > > Hi,
> > > >
> > > > I tried again and ensured that /proc/cmdline 's end was
> > > > acpi_new_pts_ordering . It did work for 2-3 hibernation, but then
> > > > failed.
> > >
> > > Well, there were quite a lot of suspend-related changes between 2.6.24
> > > and now.
> > >
> > > Hmm, do you have CONFIG_USB_SUSPEND set in .config by chance?
> > >
> > > Rafael
> >
> > I do (Debian default option)... I will build a kernel without it and
> > retry.
> >
> > Didier
>
> Hi again.
>
> I compiled the same kernel with CONFIG_USB_SUSPEND not set. After 6
> hibernations, I haven't had a problem for now.
>
> Regards,
>
> Didier

Hi again again,

It hung after the 10th hibernation...

I wonder if the problem would not be of Debian's uswsusp binary, because tt=
y1=20
tells me that the image is successfully loaded but I just can't act on my b=
ox=20
afterwards.

There is a bug open in the Debian BTS requesting a packaging of the new=20
upstream version (0.8) but the maintainer is told to be too busy to handle =
it=20
for now.

Don't know...

Regards,=20

Didier

--nextPart1588300.hqSSEA4Kmh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8dkpwW1nnOmiePARAuPvAKCUqv72osAHrZQ6onBKd9qdzK4hrACfXx1e
LzrnQpg8ml4FDxBdMFZ5WFc=
=+IBV
-----END PGP SIGNATURE-----

--nextPart1588300.hqSSEA4Kmh--
