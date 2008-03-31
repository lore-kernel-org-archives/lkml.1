Return-Path: <linux-kernel-owner+w=401wt.eu-S1756215AbYCaRDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756215AbYCaRDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYCaRDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:03:43 -0400
Received: from smtp1.infomaniak.ch ([84.16.68.89]:43028 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYCaRDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:03:42 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Mon, 31 Mar 2008 19:03:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200803311833.19730.rjw@sisk.pl>
In-Reply-To: <200803311833.19730.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2207083.YsO698HSma";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200803311903.16011.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp1 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2207083.YsO698HSma
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le lundi, 31 mars 2008 18.33:19 Rafael J. Wysocki, vous avez =E9crit=A0:
> On Monday, 31 of March 2008, Didier Raboud wrote:
> > Hi,
>
> Hi,
>
> > I'm using the latest Debian 2.6.25-rc7 kernel [0] and I have big troubl=
es
> > with hibernation. With this version, the hibernation (suspend on disk) =
is
> > sometimes not resuming correctly. The only thing I get is a blinking
> > cursor at the top-left of the screen. The problem is that it is not
> > easily reproducible=A0: sometimes it works, sometimes not.
> >
> > AFAIK, 2.6.24 is not affected, but 2.6.25-rc6 and -rc7 (at least) are.
> >
> > I'm using a Dell Latitude D630. (lspci attached).
> >
> > Attached are a 2.6.25-rc7 and a 2.6.24 dmesg's after two successful
> > hibernate/resume cycles.
>
> Could you please check if the problem is still present if you boot with
> acpi_new_pts_ordering kernel command line argument?
>
> Thanks,
> Rafael

Hi.=20

It did not help. I had to test 4 hibernation/resume cycles to see the resum=
e=20
fail.

By the way, I just added acp_new_pts_ordering at the end of the Grub line=20
beginning by "linux (hd0,1)/vmlinuz(...)". Is that correct=A0?

Regards,=20

Didier

--nextPart2207083.YsO698HSma
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH8RlTwW1nnOmiePARAgeRAKCPXO9X238yToWAG08OWlUoE6qdqACeKLNU
6S/1C5OSRsWIRCdsPGgFxvA=
=lsZz
-----END PGP SIGNATURE-----

--nextPart2207083.YsO698HSma--
