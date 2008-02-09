Return-Path: <linux-kernel-owner+w=401wt.eu-S1756433AbYBIVNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756433AbYBIVNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 16:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755551AbYBIVNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 16:13:37 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:55341 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755033AbYBIVNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 16:13:36 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Sat, 9 Feb 2008 22:13:30 +0100
User-Agent: KMail/1.9.7
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, tglx@linutronix.de,
       lenb@kernel.org, linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org> <200802091911.25730.prakash@punnoor.de> <200802091505.31567.gene.heskett@gmail.com>
In-Reply-To: <200802091505.31567.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6045087.lkmW1no4AL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802092213.30814.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6045087.lkmW1no4AL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Saturday 09 February 2008 Gene Heskett hast written:
> On Saturday 09 February 2008, Prakash Punnoor wrote:
> >On the day of Saturday 09 February 2008 Gene Heskett hast written:
> >> This has killed me both at boot time twice, once before NASH was
> >> running, and several times when uptimes were a day plus, but has never
> >> reappeared since the first time I used the acpi_user_timer_override
> >> argument, and this includes several boots without it including 2
> >> complete, 2 or 3 minute power downs.
> >
> >Are you saying that on your nforce2 you need the override
> >(acpi_use_timer_override) to have a stable system? Because that would be
> > in contrast to all previous findings regarding nforce2. Could you provi=
de
> >
> >cat /proc/interrupts
> >lspci
> >lspci -n
>
> Currently booted with it, uptime 38 hours, only diff visible is in dmesg =
as
> has been posted here in another thread.
>
> [root@coyote ~]# cat /proc/interrupts
>            CPU0
>   0:        869    XT-PIC-XT        timer
>   1:         18   IO-APIC-edge      i8042

Thanks for providing the info. According to the IDs your and my board are=20
quite alike. If you don't pass acpi_use_timer_override to vanilla kernel,=20
does your timer get connected to IO-APIC? Ie:

           CPU0
  0:      47834   IO-APIC-edge      timer

In this mode, is your board stable? I never run my hw longer than 10h, so I=
=20
cannot say anything about long-term stability, but lately my nforce2 didn't=
=20
make any troubles and (when it did, it usally was related to PSU). I am=20
skipping the override, ie. my timer is connected to IO-APIC.

If in the latter mode your hw is instable, we have a problem...
=2D-=20
(=C2=B0=3D                 =3D=C2=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart6045087.lkmW1no4AL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHrhd6xU2n/+9+t5gRAjT0AKDO/ToCCA9LFvzDi1EABVe62eNmRACgzDm7
0slnwk/B6XGYPYSuII/5WtE=
=vB4a
-----END PGP SIGNATURE-----

--nextPart6045087.lkmW1no4AL--
