Return-Path: <linux-kernel-owner+w=401wt.eu-S1760355AbXIURzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760355AbXIURzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbXIURy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:54:56 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:56644 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXIURy4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:54:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Matt Mackall <mpm@selenic.com>, Dave Airlie <airlied@gmail.com>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Fri, 21 Sep 2007 19:30:04 +0200."
             <46F3FF9C.7040200@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com> <20070920220604.GA17536@waste.org> <10207.1190394975@turing-police.cc.vt.edu>
            <46F3FF9C.7040200@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190397280_2847P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 13:54:40 -0400
Message-ID: <12650.1190397280@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190397280_2847P
Content-Type: text/plain; charset=us-ascii

On Fri, 21 Sep 2007 19:30:04 +0200, Jiri Slaby said:
> On 09/21/2007 07:16 PM, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 20 Sep 2007 17:06:05 CDT, Matt Mackall said:
> >> 2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
> >>       -rc4-mm1: solid lock on X shutdown, random solid locks about
> >>                 once every four hours
> >>       -rc6-mm1: solid lock on X startup
> >>    +your patch: screen goes black, turns off and on a few times during
> >>                 startup, can reboot with sysrq-b
> > 
> > Hmm.. maybe I'm chasing a different bug manifested by the same patch.  For me,
> > it's been a solid lockup at X startup since -rc3-mm1, and this patch doesn't
> > change matters.
> 
> This patch probably changes behaviour how the pages are queued on the list
> somehow. Maybe it's insane to suggest everybody with similar problem to try
> LIST_DEBUG, but just give it a try after having one of the patches applied ;).
> (Or have you tried yet?)

Haven't tried LIST_DEBUG yet.  I'm spending most of the weekend camping, so
will likely be unable to test that until Monday-ish (unless I get lucky and can
get a test in during the next 2 hours)...

--==_Exmh_1190397280_2847P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG9AVgcC3lWbTT17ARAnwcAKCzuCisxHIxXX9hFoScV8fpemedfQCgr+Dy
SprASULpMQozmb1Zcg7urR4=
=NXRR
-----END PGP SIGNATURE-----

--==_Exmh_1190397280_2847P--
