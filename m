Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbXKBOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbXKBOXU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 10:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbXKBOXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 10:23:04 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:54345 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755972AbXKBOXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 10:23:02 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [2.6.24-rc1][BUG] Oops on battery removal
Date: Fri, 2 Nov 2007 15:20:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>
References: <200711020803.49608.eike-kernel@sf-tec.de> <200711021426.40728.eike-kernel@sf-tec.de> <472B2924.1050700@suse.de>
In-Reply-To: <472B2924.1050700@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4917228.XQJj9LPXIp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711021520.26126.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4917228.XQJj9LPXIp
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Alexey Starikovskiy wrote:
> Rolf Eike Beer wrote:
> > Alexey Starikovskiy wrote:
> >> Rolf Eike Beer wrote:
> >>> Alexey Starikovskiy wrote:
> >>>> Rolf Eike Beer wrote:
> >>>>> Rolf Eike Beer wrote:
> >>>>>> Hi,
> >>>>>>
> >>>>>> this happened while I removed my battery on bootup. Complete dmesg
> >>>>>> is attached. Kernel is 2.6.24-rc1-git of yesterday (last commit was
> >>>>>> d919fd433b5823d1cf9d0688eb2eec183de9b74c).
> >>>>>
> >>>>> Ok, I found out that it has nothing to do with the actual removal as
> >>>>> it seems. When I start the laptop with battery already detached I g=
et
> >>>>> the same error.
> >>>>
> >>>> Please check if this patch helps.
> >>>
> >>> It made things worse:
> >>
> >> How about this patch?
> >
> > Ehm, that is the same patch as before!
>
> Yes, sorry... Two patches in parallel -- not good.

Tested-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

It makes the crash go away. But there is something weird going on. Before I=
=20
logged into X I did an "cat /proc/acpi/battery/BAT1/*" and it showed the=20
battery as present with some (random?) values. Now I'm in X and everything=
=20
looks fine there (as in "not present").

Eike

--nextPart4917228.XQJj9LPXIp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHKzIqXKSJPmm5/E4RAobqAJ4omUya+dXIl0FJKScgZZjeZYRbmgCeJOw5
H0+o/7q8yvdd9oMRpJ24WaM=
=9z1/
-----END PGP SIGNATURE-----

--nextPart4917228.XQJj9LPXIp--
