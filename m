Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbXK0Vvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbXK0Vvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 16:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbXK0Vvm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 16:51:42 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44067 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716AbXK0Vvl (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 16:51:41 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Michael Chan <mchan@broadcom.com>
Cc: linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: 2.6.23-mm1 tg3 wake-on-lan oddity...
In-Reply-To: Your message of "Tue, 27 Nov 2007 13:34:57 PST."
             <1196199297.7323.10.camel@dell>
From: Valdis.Kletnieks@vt.edu
References: <24400.1196156118@turing-police.cc.vt.edu>
            <1196199297.7323.10.camel@dell>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196200239_2895P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Nov 2007 16:50:39 -0500
Message-ID: <31913.1196200239@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196200239_2895P
Content-Type: text/plain; charset=us-ascii

On Tue, 27 Nov 2007 13:34:57 PST, Michael Chan said:

> Ideally, the BIOS should modify the NVRAM's setting when it is changed.
> We will talk to Dell to get their opinion on this as this is very
> confusing to the user.

That would certainly explain what I'm seeing, and I can certainly wait
if the answer is indeed "Buggy BIOS, fixed in D820 A08 or A09 or whenever".
(If Dell cares, I'm at BIOS A07 already).

In the meantime, I just stuck an 'ethtool -s eth0 wol d' in /etc/rc.local
until a proper fix shows up.

--==_Exmh_1196200239_2895P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHTJEvcC3lWbTT17ARAiFlAJ9busDEgNlG21KtqThegab5GmgQDACgl9Ur
S9FwWUDBgJO/4s8T1YAIhl4=
=spKL
-----END PGP SIGNATURE-----

--==_Exmh_1196200239_2895P--
