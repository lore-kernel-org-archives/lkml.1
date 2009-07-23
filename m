Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZGWUe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZGWUe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 16:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZGWUe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 16:34:27 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45267 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461AbZGWUe1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 16:34:27 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Subject: Re: Generic events for wake up from S1-S4
In-Reply-To: Your message of "Thu, 23 Jul 2009 21:51:14 +0200."
             <20090723195114.GR28158@elf.ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> <43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com> <20090718103756.GA11381@elf.ucw.cz> <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com> <20090718235609.GC25343@khazad-dum.debian.net> <20090723145757.GB28158@elf.ucw.cz> <20090723185720.GB19369@khazad-dum.debian.net> <20090723191330.GQ28158@elf.ucw.cz> <20090723194522.GC19369@khazad-dum.debian.net>
            <20090723195114.GR28158@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1248381087_2742P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 23 Jul 2009 16:31:27 -0400
Message-ID: <8233.1248381087@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1248381087_2742P
Content-Type: text/plain; charset=us-ascii

On Thu, 23 Jul 2009 21:51:14 +0200, Pavel Machek said:

> Ok, but then we should not be talking about wake up events,
> but... events.
> 
> Like "lid opened", "wake packet came", ... . And deliver them even
> when they happen during run-time. That's okay with me.

That's actually a sane thing to do - for instance, one of the main uses
of "wake on LAN" in many environments is to wake up a box to do software
upgrades.  And if we're already up-and-running, and we "know" (from site
policy) that a W-o-L packet is only sent because IT is pushing updates,
it may make a lot of sense to catch a "wake packet" event, and go ahead
and start the software updater *anyhow* (with suitable notification/confirm
dialog to the poor guy still working on that presentation at 2AM, of course :)

--==_Exmh_1248381087_2742P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKaMifcC3lWbTT17ARAu2sAKDA/dboEFbNyilO81vl+K2+2FRfNQCg5Atz
FLf3vt4cWbfP7B3BYfIvNAc=
=YQtg
-----END PGP SIGNATURE-----

--==_Exmh_1248381087_2742P--
