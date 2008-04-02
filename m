Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbYDBMHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbYDBMHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 08:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162AbYDBMHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 08:07:03 -0400
Received: from smtp1.infomaniak.ch ([84.16.68.89]:50433 "EHLO
	smtp1.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYDBMHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 08:07:01 -0400
From: Didier Raboud <didier@raboud.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: =?iso-8859-15?q?2=2E6=2E25-rc7=A0=3A_hibernation_sometimes_not_resuming_on?=
 =?iso-8859-15?q?_Dell_Latitude?= D630
Date: Wed, 2 Apr 2008 14:06:29 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
References: <200803311823.36693.didier@raboud.com> <200804012318.26002.didier@raboud.com> <200804012322.35672.rjw@sisk.pl>
In-Reply-To: <200804012322.35672.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1900600.ZKocu9aPAs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804021406.32668.didier@raboud.com>
X-Antivirus: Dr.Web (R) for Mail Servers on smtp1 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1900600.ZKocu9aPAs
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le mardi, 1 avril 2008 23.22:35 Rafael J. Wysocki, vous avez =E9crit=A0:
> On Tuesday, 1 of April 2008, Didier Raboud wrote:
> > Le mardi, 1 avril 2008 23.11:15 Rafael J. Wysocki, vous avez =E9crit=A0:
> > > (...)
> > > Can you please test the in-kernel hibernation, then?
> > >
> > > Rafael
> >
> > Hi,
> >
> > would like to. How=A0?
> >
> > # echo -n disk > /sys/power/state
>
> Yes, should work without the "-n", too.  Of course, you have to use the
> 'resume=3D' kernel command line argument for this to work.
>
> Perhaps increase the console log level before that.
>
> Thanks,
> Rafael

Ok. I found a "better" way to do it=A0: just uninstall uswsusp and let=20
kpowersave use hal to use suspend :-)

Anyway, so far so good (with USB_SUSPEND not set), no hang. I will test wit=
h=20
USB_SUSPEND set and the incoming 2.6.25-rc8.

Regards,=20

Didier

--nextPart1900600.ZKocu9aPAs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH83bIwW1nnOmiePARApARAJ9orfuxozIfXDyfdRTHWQt5+jtqNQCeK0Et
rYfWUBaM6sJF84q3TvtrSqE=
=FS5W
-----END PGP SIGNATURE-----

--nextPart1900600.ZKocu9aPAs--
