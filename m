Return-Path: <linux-kernel-owner+w=401wt.eu-S1758325AbYBRRbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325AbYBRRbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbYBRRbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:31:24 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45144 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbYBRRbW (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:31:22 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Geert Uytterhoeven <geert@linux-m68k.org>, avorontsov@ru.mvista.com,
       linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] fb: add support for foreign endianness
In-Reply-To: Your message of "Mon, 18 Feb 2008 08:18:47 +0100."
             <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
From: Valdis.Kletnieks@vt.edu
References: <20080205154432.GA8749@localhost.localdomain> <20080214224942.a0cb6218.akpm@linux-foundation.org> <20080215164542.GB16810@localhost.localdomain> <Pine.LNX.4.64.0802171030330.6848@anakin>
            <20080218081847.e9e65f2f.krzysztof.h1@poczta.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1203355811_2991P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 18 Feb 2008 12:30:11 -0500
Message-ID: <19805.1203355811@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1203355811_2991P
Content-Type: text/plain; charset=us-ascii

On Mon, 18 Feb 2008 08:18:47 +0100, Krzysztof Helt said:
> I know two fb drivers which use endianess information (pm2fb and s3c2410fb).
> Both resolve endianess at driver level. Actually, both handle it by setting special
> bits so the graphics chip itself reorder bytes to transform foreign endianess. 
> I understand that this patch is for chips which cannot reorder bytes by themselves.

Does anybody know of such a chip that's actually available in the wild?  Or are
we writing drivers for speculative possible chips?

--==_Exmh_1203355811_2991P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHucCjcC3lWbTT17ARAs3WAJsF9CsHmgfsLvqldWPilbhoVFS5NACfTFrJ
i5E2PGuWzLogM8fqDx25xCo=
=be6Y
-----END PGP SIGNATURE-----

--==_Exmh_1203355811_2991P--
