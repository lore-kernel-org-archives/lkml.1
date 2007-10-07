Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXJGODO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXJGODO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 10:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXJGOC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 10:02:59 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39164 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbXJGOC7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 10:02:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Helge Deller <deller@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] Time-based RFC 4122 UUID generator
In-Reply-To: Your message of "Sun, 07 Oct 2007 12:08:10 +0200."
             <200710071208.11030.deller@gmx.de>
From: Valdis.Kletnieks@vt.edu
References: <200710061553.37311.deller@gmx.de> <20668.1191728530@turing-police.cc.vt.edu>
            <200710071208.11030.deller@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1191765776_10413P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 07 Oct 2007 10:02:56 -0400
Message-ID: <2018.1191765776@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1191765776_10413P
Content-Type: text/plain; charset=us-ascii

On Sun, 07 Oct 2007 12:08:10 +0200, you said:

> Thanks that you ask! 
> I really should have mentioned it in my initial posting.
> 
> Yes, this change was intentional, as it in fact fixes a possible bug in the original code.
> Section 4.1.6 in RFC 4122 states regarding the "NodeID":
> :  For systems with no IEEE address, a randomly or pseudo-randomly
> :  generated value may be used; see Section 4.5.  The multicast bit must
> :  be set in such addresses, in order that they will never conflict with
> :  addresses obtained from network cards. 
> 
> So up to now it was just pure ("random") luck if this bit was set or not.

Sounds like a valid bugfix then - but it should probably be sent upstream
separately, with it's own changelog (what I quoted above should be fine)...

Remember - one patch, one logical change, so your patch should be split up
(among other things, that way the bugfix can proceed even if the new-function
part gets hung up in review).....

Other than splitting it up, I have no further comments on either part.. Enjoy...

--==_Exmh_1191765776_10413P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHCOcQcC3lWbTT17ARAlPkAKDuGvbOuqi5HU4Tlaeb4nEamjG4mQCeNXH+
5/GyopvmiWlYgrNiGoTFVgg=
=FAFY
-----END PGP SIGNATURE-----

--==_Exmh_1191765776_10413P--
