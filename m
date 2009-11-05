Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZKECZE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZKECZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:25:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZKECZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:25:03 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:52618 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbZKECZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:25:02 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Martin Nybo Andersen <tweek@tweek.dk>,
       kevin granade <kevin.granade@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Ryan C. Gordon" <icculus@icculus.org>,
       =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: package managers [was: FatELF patches...]
In-Reply-To: Your message of "Thu, 05 Nov 2009 00:55:53 +0100."
             <Pine.LNX.4.64.0911050019540.1469@artax.karlin.mff.cuni.cz>
From: Valdis.Kletnieks@vt.edu
References: <alpine.DEB.2.00.0910271410510.16178@andre.icculuslan> <7004b08e0911041332x259c02afg612be7eb02e4d6bb@mail.gmail.com> <Pine.LNX.4.64.0911042244030.24799@artax.karlin.mff.cuni.cz> <200911042343.01957.tweek@tweek.dk>
            <Pine.LNX.4.64.0911050019540.1469@artax.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257387887_4430P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 21:24:47 -0500
Message-ID: <5659.1257387887@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020209.4AF23770.01C5,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257387887_4430P
Content-Type: text/plain; charset=us-ascii

On Thu, 05 Nov 2009 00:55:53 +0100, Mikulas Patocka said:

> In some situations, the package manager is even more dangerous than manual 
> install. For example, if you are manually installing new alpha-quality 
> version of mplayer, and it is buggy, you end up with a working system with 
> broken mplayer. If you install alpha-quality version from some package 
> repository, it may need experimental version of libfoo, that needs 
> experimental version of libfee, that needs experimental version of glibc, 
> that contains a bug 

Total bullshit.  You know *damned* well that if you were installing that alpha
version of mplayer by hand, and it needed experimental libfoo, you'd go and
build libfoo by hand, and then build the experimental libfee by hand, and then
shoehorn in that glibc by hand, and bricked your system anyhow.

Or if you're arguing "you'd give up after seeing it needed an experimental
libfoo", I'll counter "you'd hopefully think twice if yum said it was
installing a experimental mplayer, and dragging in a whole chain of pre-reqs".

And any *sane* package manager won't even *try* to install an experimental one
unless you specifically *tell* it that the vendor-testing repository is
fair game.  You install Fedora, it looks in Releases and Updates.  You want
it to look for testing versions in Rawhide, you have to enable that by hand.
I'm positive Debian and Ubuntu and Suse are similar.

Plus, building by hand you're *more* likely to produce a brick-able library,
because you didn't specify the same './configure --enable-foobar' flags that
the rest of your system was expecting. (Been there, done that - reported a
Fedora Rawhide bug that an X11 upgrade borked the keyboard mapping, so the
keysym reported for 'uparrow' was 'Katakana', among other things.  Actual root
cause - running a -mm kernel that didn't have CONFIG_INPUT_EVDEV defined.
Previous X didn't care, updated it. Whoops).


--==_Exmh_1257387887_4430P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8jdvcC3lWbTT17ARAjOFAJ99XYmg80a/ilnRo/q6Gou3FDklBACfRq86
vV2Oifucq+xaXnnYOhoowDQ=
=04Tb
-----END PGP SIGNATURE-----

--==_Exmh_1257387887_4430P--

