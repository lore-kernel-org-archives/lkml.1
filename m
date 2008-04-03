Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbYDCNmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbYDCNmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYDCNmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:42:17 -0400
Received: from smtp2.infomaniak.ch ([84.16.68.90]:53155 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbYDCNmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:42:16 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?utf-8?q?2=2E6=2E25-rc7=C2=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?utf-8?q?_Dell_Latitude?= D630
Date: Thu, 3 Apr 2008 15:41:36 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200804012322.35672.rjw@sisk.pl> <200804021406.32668.didier@raboud.com>
In-Reply-To: <200804021406.32668.didier@raboud.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2527026.Ip2iGGJ1E7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804031541.38493.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2527026.Ip2iGGJ1E7
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le mercredi, 2 avril 2008 14.06:29 Didier Raboud, vous avez =C3=A9crit=C2=
=A0:
> Le mardi, 1 avril 2008 23.22:35 Rafael J. Wysocki, vous avez =C3=A9crit=
=C2=A0:
> > On Tuesday, 1 of April 2008, Didier Raboud wrote:
> > > Le mardi, 1 avril 2008 23.11:15 Rafael J. Wysocki, vous avez =C3=A9cr=
it=C2=A0:
> > > > (...)
> > > > Can you please test the in-kernel hibernation, then?
> > > >
> > > > Rafael
> > >
> > > Hi,
> > >
> > > would like to. How=C2=A0?
> > >
> > > # echo -n disk > /sys/power/state
> >
> > Yes, should work without the "-n", too.  Of course, you have to use the
> > 'resume=3D' kernel command line argument for this to work.
> >
> > Perhaps increase the console log level before that.
> >
> > Thanks,
> > Rafael
>
> Ok. I found a "better" way to do it=C2=A0: just uninstall uswsusp and let
> kpowersave use hal to use suspend :-)
>
> Anyway, so far so good (with USB_SUSPEND not set), no hang. I will test
> with USB_SUSPEND set and the incoming 2.6.25-rc8.
>
> Regards,
>
> Didier

So far so good too with "stock" Debian Kernel (2.7.25-rc7-amd64) with=20
USB_SUSPEND set. No hang.

The kernel suspend is less user-friendly than uswsusp though...

So I bet there is a bug in uswsusp's kernel part ?

Regards,=20

Didier

--nextPart2527026.Ip2iGGJ1E7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD4DBQBH9N6SwW1nnOmiePARAiLpAJY5gS4w1B4zBZHQ/63JDP8r2PggAJ9qJFi5
kOCcSxLNgN8AZULU1zmyeQ==
=w0Te
-----END PGP SIGNATURE-----

--nextPart2527026.Ip2iGGJ1E7--
