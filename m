Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbXIURQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbXIURQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 13:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020AbXIURQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 13:16:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40200 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbXIURQ2 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 13:16:28 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Matt Mackall <mpm@selenic.com>
Cc: Dave Airlie <airlied@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Thu, 20 Sep 2007 17:06:05 CDT."
             <20070920220604.GA17536@waste.org>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <21d7e9970709191842h3111390cl8f09745bed6bd8f9@mail.gmail.com>
            <20070920220604.GA17536@waste.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190394975_2847P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 21 Sep 2007 13:16:15 -0400
Message-ID: <10207.1190394975@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190394975_2847P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Sep 2007 17:06:05 CDT, Matt Mackall said:
> On Thu, Sep 20, 2007 at 11:42:29AM +1000, Dave Airlie wrote:

> > I've attached a more complicated patch that does a 2 stage effort to
> > unmapping and freeing pages. My kernel no longer hangs with this
> > patch...
> > 
> > Jiri can you confirm?
> 
> It's broken for me.
> 
> 2.6.23-rc3-mm1: solid lock on X shutdown (noticed when upgrading)
>       -rc4-mm1: solid lock on X shutdown, random solid locks about
>                 once every four hours
>       -rc6-mm1: solid lock on X startup
>    +your patch: screen goes black, turns off and on a few times during
>                 startup, can reboot with sysrq-b

Hmm.. maybe I'm chasing a different bug manifested by the same patch.  For me,
it's been a solid lockup at X startup since -rc3-mm1, and this patch doesn't
change matters.

--==_Exmh_1190394975_2847P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8/xfcC3lWbTT17ARAg0qAKDD7pHlRI2vufJCqPeJP5PpY4DzAwCgslAP
gzWRo7Dub94TjjF1yrRE1ZI=
=7RdW
-----END PGP SIGNATURE-----

--==_Exmh_1190394975_2847P--
