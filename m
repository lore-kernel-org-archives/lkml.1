Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbYCEVxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbYCEVxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbYCEVxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:53:46 -0500
Received: from hc6521041.dhcp.vt.edu ([198.82.16.65]:53067 "EHLO
	hc6521041.dhcp.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbYCEVxp (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:53:45 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 - PROFILE_LIKELY redux..
In-Reply-To: Your message of "Wed, 05 Mar 2008 18:45:13 +0100."
             <p738x0x5al2.fsf@bingen.suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org> <4911.1204701694@turing-police.cc.vt.edu>
            <p738x0x5al2.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204747197_20005P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Mar 2008 14:59:57 -0500
Message-ID: <25220.1204747197@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204747197_20005P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Mar 2008 18:45:13 +0100, Andi Kleen said:
> Valdis.Kletnieks@vt.edu writes:
> >
> > So we're in the same 4K as the VDSO64_* values, but some 0x4fe past the
> > gtod_data.  Anybody got a hint as to what the heck it was doing?
> 
> Try this patch:
> 
> Remove unlikelies in vsyscall path

Nope, sorry... same behavior.  Apparently it's a (un)likely someplace
else...

I'm trying to figure out what's at 0x9be into the vdso, but not having
a lot of luck.

--==_Exmh_1204747197_20005P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHzvu9cC3lWbTT17ARApNuAJ9uHrq+LCB3NnA7meBe1aMWARZYqQCeLcd4
3WecDSPTXlLsPRzMQ/ReR6M=
=glIm
-----END PGP SIGNATURE-----

--==_Exmh_1204747197_20005P--
