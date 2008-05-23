Return-Path: <linux-kernel-owner+w=401wt.eu-S1759233AbYEWVeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759233AbYEWVeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 17:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756840AbYEWVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 17:33:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbYEWVdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 17:33:53 -0400
Date: Fri, 23 May 2008 23:33:48 +0200
From: Bernhard Walle <bwalle@suse.de>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Sharyathi Nagesh <sharyath@in.ibm.com>, akpm@osdl.org,
       mohd.omar@in.ibm.com, IndhuDurai@in.ibm.com,
       Kexec Mailing List <kexec@lists.infradead.org>, fastboot@lists.osdl.org,
       linux-kernel@vger.kernel.org, mohan@in.ibm.com, sachinp@in.ibm.com
Subject: Re: correction to compat_sys_kexec_load
Message-ID: <20080523233348.13fe0c63@kopernikus.site>
In-Reply-To: <m1ve144w25.fsf@frodo.ebiederm.org>
References: <4836AC3C.3090005@in.ibm.com>
	<m1ve144w25.fsf@frodo.ebiederm.org>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UD+KsdZykL9myZF89pu6F+C";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UD+KsdZykL9myZF89pu6F+C
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

* ebiederm@xmission.com (Eric W. Biederman) [2008-05-23 13:14]:
>
> What we need to do is fix /sbin/kexec to pass in the correct
> architecture of the kernel for unload as it does for load.

How should it know that it unloads a 32 bit kernel on a 64 bit system?
It doesn't have access to the kernel any more once it has been loaded.



	Bernhard

PS: My mail server complains that  maneesh@in.ltcfwd.linux.ibm.com is
invalid because "Recipient address rejected: Domain not found". Maybe
some of the other IBM guys in Cc can take a look at this ... I just
removed that address from Cc for now.

--Sig_/UD+KsdZykL9myZF89pu6F+C
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFINzg8iGU2lt2vZFQRAvUFAJ9tzHrmY+M1caR137Ay9d2hDFso2gCgqXc6
jAYk/290hNDvb8Ya2a/iZOo=
=8VmB
-----END PGP SIGNATURE-----

--Sig_/UD+KsdZykL9myZF89pu6F+C--
