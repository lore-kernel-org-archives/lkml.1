Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZHFOhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZHFOhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 10:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbZHFOhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 10:37:37 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36554 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbZHFOhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 10:37:36 -0400
Date: Thu, 6 Aug 2009 09:36:28 -0500
From: Clark Williams <williams@redhat.com>
To: gowrishankar.m@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
Subject: Re: [ANNOUNCE] 2.6.31-rc4-rt1 (problem with
 CONFIG_SYSFS_DEPRECATED_V2)
Message-ID: <20090806093628.216bb27f@torg>
In-Reply-To: <4A7A7C37.7020609@linux.vnet.ibm.com>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	<alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	<alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	<alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	<alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	<alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	<alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	<alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	<alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	<alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	<alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	<alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	<alpine.LFD.2.00.0907300006250.2936@localhost.localdomain>
	<4A79214B.5070003@linux.vnet.ibm.com>
	<20090805083247.0b84d1c0@torg>
	<4A7A7C37.7020609@linux.vnet.ibm.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LySjAB79UpgUp5fCcJb3DgR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LySjAB79UpgUp5fCcJb3DgR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 06 Aug 2009 12:16:15 +0530
gowrishankar <gowrishankar.m@linux.vnet.ibm.com> wrote:

> Only if I set CONFIG_SYSFS_DEPRECATED_V2=3Dy, I could successfully boot
> which I have tested with this kernel in same system.
>=20
> Is it not set by default from 2.6.31 onwards ?
>=20
> Thanks,
> Gowri

I wasn't sure when it would move from 'y' to 'n', but looks like .31 is
it. You'll need that option back on for booting on RHEL (since the boot
infrastructure uses the old /sys format) but I don't think you'll need
it for Fedora. Not sure about SLERT. Bet Greg Haskins would know
though :)

Clark

--Sig_/LySjAB79UpgUp5fCcJb3DgR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkp66nAACgkQHyuj/+TTEp1nngCdHHQyf8CyA3GiF38lwc5mWL7w
3PQAn2ola9hi5QdbI/zrz+Un+FqyOL/T
=NGHx
-----END PGP SIGNATURE-----

--Sig_/LySjAB79UpgUp5fCcJb3DgR--
