Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXK1SPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXK1SPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbXK1SP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:15:28 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33110 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbXK1SP1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:15:27 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christoph Hellwig <hch@infradead.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: Your message of "Wed, 28 Nov 2007 16:46:13 GMT."
             <20071128164613.GA21815@infradead.org>
From: Valdis.Kletnieks@vt.edu
References: <20071128144156.GA14106@infradead.org> <416908.77038.qm@web36613.mail.mud.yahoo.com>
            <20071128164613.GA21815@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196273705_3040P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 28 Nov 2007 13:15:05 -0500
Message-ID: <25290.1196273705@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196273705_3040P
Content-Type: text/plain; charset=us-ascii

On Wed, 28 Nov 2007 16:46:13 GMT, Christoph Hellwig said:
> On Wed, Nov 28, 2007 at 08:38:43AM -0800, Casey Schaufler wrote:
> > Would you like to expound on that, or do you feel your claws
> > are sharp enough already?
> 
> Just take a look at code.

Just to clarify - you're OK with the *concept* (a security model that determines
whether you can do an I/O based on the content), it's just their code that's
ugly?

(Note that the concept has interesting implications in the other direction as
well - rather than stopping you from reading a file that has malware, you could
in theory write an anti-export package that would let you write onto external
memory or outbound e-mail, but prevent the write if it was corporate-sensitive
data, or whatever.  Yes, I *know* a smart attacker can bypass it by simply
crypting/compressing it first - but the vast majority of attackers aren't
smart, and will just use 'cp' or the GUI equivalent to move the secret design
documents onto the USB key... )

--==_Exmh_1196273705_3040P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHTbApcC3lWbTT17ARAjFvAKCsgmrCBJ9r2j+OHSb1V4XaTpe6awCdE2xs
TFGo8yF4+MazfV/epARRDKM=
=yHDR
-----END PGP SIGNATURE-----

--==_Exmh_1196273705_3040P--
