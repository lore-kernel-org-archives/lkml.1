Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbZAPPRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbZAPPRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 10:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757753AbZAPPRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 10:17:30 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51033 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755315AbZAPPR2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 10:17:28 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Takashi Sato <t-sato@yk.jp.nec.com>
Subject: Re: [PATCH] Allow SysRq emergency sync to thaw frozen filesystems
In-Reply-To: Your message of "Fri, 16 Jan 2009 09:48:28 +0100."
             <20090116084828.GB4795@atrey.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <496EB639.6090800@redhat.com>
            <20090116084828.GB4795@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1232119029_11157P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 16 Jan 2009 10:17:09 -0500
Message-ID: <16406.1232119029@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1232119029_11157P
Content-Type: text/plain; charset=us-ascii

On Fri, 16 Jan 2009 09:48:28 +0100, Pavel Machek said:

> Emergency Sync should not do this. Invent another key.
> 
> ...because otherwise, if you hit emergency sync but the system is
> still alive and relies on filesystem freezing, bad stuff will happen.

Under what conditions would a system be alive and relying on freezing,
*and* an emergency thaw would be worse than whatever reason you're doing
an emergency sync?

Hmm.. guess you *could* get into trouble if you tried to do a Sysrq-[not-s]
and hit the wrong key - but you have the same danger if you have *any*
sysrq- invoking an emergency_thaw and hit it by accident...


--==_Exmh_1232119029_11157P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJcKT1cC3lWbTT17ARAkxTAKD7kM4SXpoIq3HrEawjs648LxRppgCeMdoI
e4CNEavZX4mczoldQXYa5PA=
=1cuZ
-----END PGP SIGNATURE-----

--==_Exmh_1232119029_11157P--
