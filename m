Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXH1UrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXH1UrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXH1Uqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:46:54 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53370 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbXH1Uqx (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:46:53 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Boldi <a1426z@gawab.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
In-Reply-To: Your message of "Mon, 27 Aug 2007 22:05:37 PDT."
             <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200708111344.42934.a1426z@gawab.com> <200708271746.47685.a1426z@gawab.com> <20070827204116.GA12495@elte.hu> <200708280737.53439.a1426z@gawab.com>
            <alpine.LFD.0.999.0708272153530.25853@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1188334665_3159P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 16:46:08 -0400
Message-ID: <14311.1188333968@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1188334665_3159P
Content-Type: text/plain; charset=us-ascii

On Mon, 27 Aug 2007 22:05:37 PDT, Linus Torvalds said:
> 
> 
> On Tue, 28 Aug 2007, Al Boldi wrote:
> > 
> > No need for framebuffer.  All you need is X using the X.org vesa-driver.  
> > Then start gears like this:
> > 
> >   # gears & gears & gears &
> > 
> > Then lay them out side by side to see the periodic stallings for ~10sec.
> 
> I don't think this is a good test.
> 
> Why?
> 
> If you're not using direct rendering, what you have is the X server doing 
> all the rendering, which in turn means that what you are testing is quite 
> possibly not so much about the *kernel* scheduling, but about *X-server* 
> scheduling!

I wonder - can people who are doing this as a test please specify whether
they're using an older X that has the libX11 or the newer libxcb code? That
may have a similar impact as well.

(libxcb is pretty new - it landed in Fedora Rawhide just about a month ago,
after Fedora 7 shipped.  Not sure what other distros have it now...)

--==_Exmh_1188334665_3159P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG1ImQcC3lWbTT17ARAqc1AJ4hU1D9OS3uZgXTJBeHx6izl+HEtQCgqZxP
I0hfqqjkVb9a58tkrXB7qu4=
=0rP7
-----END PGP SIGNATURE-----

--==_Exmh_1188334665_3159P--
