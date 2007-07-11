Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXGKWM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXGKWM1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761997AbXGKWMS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:12:18 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:50493 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761817AbXGKWMR (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:12:17 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86 status was Re: -mm merge plans for 2.6.23
In-Reply-To: Your message of "Wed, 11 Jul 2007 14:54:12 PDT."
             <20070711215412.GZ4306@sequoia.sous-sol.org>
From: Valdis.Kletnieks@vt.edu
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <p734pkbyuu4.fsf@bingen.suse.de> <20070711174252.GA16793@elte.hu> <20070711211638.GE18767@one.firstfloor.org> <28188.1184190381@turing-police.cc.vt.edu>
            <20070711215412.GZ4306@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1184191888_3416P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jul 2007 18:11:28 -0400
Message-ID: <29701.1184191888@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1184191888_3416P
Content-Type: text/plain; charset=us-ascii

On Wed, 11 Jul 2007 14:54:12 PDT, Chris Wright said:
> * Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> > On Wed, 11 Jul 2007 23:16:38 +0200, Andi Kleen said:
> > (Note - I'm just a usually-confused crash test dummy here...)
> > 
> > > Well I spent a lot of time making the x86-64 timing code work
> > > well on a variety of machines; working around a wide variety
> > > of hardware and platform bugs. I obviously don't agree on your description
> > > of its maintenance state. 
> > 
> > I'm seeing a bit of a disconnect here.  If you spent all that time making it
> > work, how come the guys who developed the patch are saying you didn't provide
> > any feedback about the patchset?
> 
> I think Andi's referring to the existing x86_64 code, which gets
> replaced by the patchset in question.

<Takes a closer look at the patches>  D'Oh! :)  Yeah, the -rc4 version I'm
looking at is like a dozen 1-3K patches setting up and cleaning up, and then
one monster 65K patch doing the clockevents conversion, then another 6 or 8
small ones.

Yeah, that one big patch really doesn't look separable to me.  But as I said,
I'm just a crash test dummy here. :)

Andrew - how do you feel about keeping this in the -mm tree until Linus,
Andi, Ingo, and Thomas get on the same page (which may be around the 2.6.24
merge window, by my guesstimate)?


--==_Exmh_1184191888_3416P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGlVWQcC3lWbTT17ARAomuAJ0ZKvVtXCOYkM4hr6x8lkJxDaQDWACg8fgQ
GJ6loMYZASmfEbQfq0NMsNI=
=0zDc
-----END PGP SIGNATURE-----

--==_Exmh_1184191888_3416P--
