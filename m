Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbZDPTtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbZDPTtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 15:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZDPTtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 15:49:33 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:48152 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757756AbZDPTtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 15:49:32 -0400
X-Greylist: delayed 1918 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Apr 2009 15:49:32 EDT
Date: Thu, 16 Apr 2009 21:18:02 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: David Rientjes <rientjes@google.com>
Cc: Nikola Ciprich <extmaillist@linuxbox.cz>,
       David Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29.1: BUG: sleeping function called from invalid context
	at mm/slub.c:1599
Message-ID: <20090416191802.GC5024@nik-comp.linuxbox.cz>
References: <20090415145841.GA5106@nik-comp.linuxbox.cz> <alpine.DEB.2.00.0904151127430.14961@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kfjH4zxOES6UT95V"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904151127430.14961@chino.kir.corp.google.com>
"X-PGP-Key: http://nik.lbox.cz/downloads/nikola.ciprich.asc"
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Antivirus: on proxybox by Kaspersky antivirus, engine 5.5.10, data 1855283 records(16-04-2009)
X-Spam-Score: N/A (trusted relay)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kfjH4zxOES6UT95V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,
thanks for a reply.
I've also created a SGI bugzilla report:
http://oss.sgi.com/bugzilla/show_bug.cgi?id=3D819
BR
nik

On Wed, Apr 15, 2009 at 11:33:54AM -0700, David Rientjes wrote:

> David, do you think this could be related to holding pag->pag_ici_lock=20
> while calling xfs_iget_cache_hit() in=20
> 6441e549157b749bae003cce70b4c8b62e4801fa?


--=20
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--kfjH4zxOES6UT95V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJ54Rq3xdJJrLygV4RAt5cAJwIhhbLn5PYD74PPQqWMMgAnVOXVQCgwJGx
pjZ5iQrLM3IuEZbdkMlcHXM=
=HtBB
-----END PGP SIGNATURE-----

--kfjH4zxOES6UT95V--
