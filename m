Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbXK0DpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbXK0DpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:45:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXK0DpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:45:00 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:60914 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbXK0Do7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:44:59 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] remove CONFIG_EXPERIMENTAL
In-Reply-To: Your message of "Mon, 26 Nov 2007 12:27:07 GMT."
             <20071126122706.GA5167@ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <20071125161631.GA21947@stusta.de>
            <20071126122706.GA5167@ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196135084_2838P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 26 Nov 2007 22:44:44 -0500
Message-ID: <20547.1196135084@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196135084_2838P
Content-Type: text/plain; charset=us-ascii

On Mon, 26 Nov 2007 12:27:07 GMT, Pavel Machek said:

> I don't think this is good idea. But perhaps 'experimental' should be
> removed from stuff that is really stable these days, like SATA?

I suspect that given the "once it escapes, it's cast in stone" view we take
towards user-visible API/etc, there isn't much *real* room for an
'EXPERIMENTAL' flag anymore.  Most of the usage should probably be confined to
individual drivers, where all we should need is a 'default n' and suitable
warning verbiage in the Kconfig file warning about the driver eating your
filesystems and small animals for breakfast.  We certainly shouldn't have
one big flag for *all* in-progress drivers - I don't need to accidentally
enable a busticated ethernet driver because I want a USB widget.  And if
you're worried about people accidentally enabling it, then *each driver*
should have a 'Do you really mean it?' flag with *opposite* sense (so
that 'make allyesconfig' doesn't turn it on by accident).

Anything bigger than that, we probably want to redefine 'experimental'
as "it doesn't escape from -mm to mainline till it's ready".

--==_Exmh_1196135084_2838P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHS5KscC3lWbTT17ARArb4AJ48twgmTqg3g6WJs3mp5ji0W/aU+gCg+cPZ
cQFnzeAHCa5qtF/veIgqxDA=
=y0y4
-----END PGP SIGNATURE-----

--==_Exmh_1196135084_2838P--
