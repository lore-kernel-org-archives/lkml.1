Return-Path: <linux-kernel-owner+w=401wt.eu-S1758383AbXHaPEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383AbXHaPEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXHaPEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:04:46 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34072 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbXHaPEp (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:04:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Adrian Bunk <bunk@kernel.org>
Cc: Oliver Neukum <oliver@neukum.org>, linux-kernel@vger.kernel.org
Subject: Re: possible build system oddity
In-Reply-To: Your message of "Fri, 31 Aug 2007 10:42:29 +0200."
             <20070831084229.GE9260@stusta.de>
From: Valdis.Kletnieks@vt.edu
References: <200708311037.29280.oliver@neukum.org>
            <20070831084229.GE9260@stusta.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188572427_3280P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 31 Aug 2007 11:00:27 -0400
Message-ID: <26547.1188572427@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188572427_3280P
Content-Type: text/plain; charset=us-ascii

On Fri, 31 Aug 2007 10:42:29 +0200, Adrian Bunk said:
> On Fri, Aug 31, 2007 at 10:37:28AM +0200, Oliver Neukum wrote:
> > Hi,
> > 
> > I only touched sound/usb/usbaudio.c
> > Nevertheless the whole subtree und sound/ is recompiling. What's
> > happening?
> 
> The only file that gets compiled (CC) should be sound/usb/usbaudio.c
> 
> It seems you are confused by the fact that this recompilation results in 
> several relinks (LD)?

Or something else changed that he didn't realize.  Just the other day, I
applied a one-line patch that hit one .c file, and *the entire kernel*
started rebuilding.

Took me a while to figure out that I'd been looking for something else, and
done a 'vi Makefile' in the top level, and exited with 'ZZ' rather than ':q' ;)


--==_Exmh_1188572427_3280P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG2C0LcC3lWbTT17ARAtixAJ9NLGnASngAc4d/Z62Ma+LZGEtZNQCfSZOw
SHnI6Vzevmj++5tsfetzNPI=
=Rd/j
-----END PGP SIGNATURE-----

--==_Exmh_1188572427_3280P--
