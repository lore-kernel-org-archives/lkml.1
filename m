Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbXK1UF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbXK1UF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbXK1UFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:05:16 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43258 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbXK1UFP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:05:15 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: Your message of "Wed, 28 Nov 2007 19:52:46 GMT."
             <20071128195246.25304758@the-village.bc.nu>
From: Valdis.Kletnieks@vt.edu
References: <200711281242.52941.tvrtko.ursulin@sophos.com> <p738x4i9nyd.fsf@crumb.suse.de>
            <20071128195246.25304758@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196280301_3040P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Nov 2007 15:05:01 -0500
Message-ID: <31816.1196280301@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196280301_3040P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Nov 2007 19:52:46 GMT, Alan Cox said:
> > It might be better to identify the services (gateway, samba, file
> > server whatever) that are actually dealing with possible infected
> > "external" files and then define some generic interface that would
> > allow you to check those as the data appears.
> 
> I am wondering if the right interface is actually more related to the
> existing audit interfaces ?

The problem there is that the audit interface just *records* - it doesn't
have the ability to say "No, I don't *think* so.." that the LSM interface has.

--==_Exmh_1196280301_3040P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHTcntcC3lWbTT17ARAvKHAJ9L7BP0hVTvrzYjROOBDdcivYhucQCfdqiP
H9pQThpbTgmE21QheWiRMYI=
=K8ip
-----END PGP SIGNATURE-----

--==_Exmh_1196280301_3040P--
