Return-Path: <linux-kernel-owner+w=401wt.eu-S1762061AbXK3GVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbXK3GVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 01:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbXK3GVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 01:21:10 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58099 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXK3GVJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 01:21:09 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jon Masters <jonathan@jonmasters.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray-lk@madrabbit.org>,
       tvrtko.ursulin@sophos.com, Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: Your message of "Thu, 29 Nov 2007 18:34:33 EST."
             <1196379273.6473.121.camel@perihelion>
From: Valdis.Kletnieks@vt.edu
References: <20071128183040.GW8181@ftp.linux.org.uk> <OF699E23DA.E36E712D-ON802573A2.00591FA8-802573A2.005A44A2@sophos.com> <20071129173601.34273083@the-village.bc.nu> <2c0942db0711291040j4ce48acagb753b64c4b8c1357@mail.gmail.com> <1196362612.6473.98.camel@perihelion> <2c0942db0711291111t16a4eb49h6b1e83ddf7bb4cf9@mail.gmail.com> <1196365551.6473.103.camel@perihelion> <20071129214527.1d62056c@the-village.bc.nu>
            <1196379273.6473.121.camel@perihelion>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196403614_4697P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 30 Nov 2007 01:20:14 -0500
Message-ID: <21029.1196403614@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196403614_4697P
Content-Type: text/plain; charset=us-ascii

On Thu, 29 Nov 2007 18:34:33 EST, Jon Masters said:
> 
> On Thu, 2007-11-29 at 21:45 +0000, Alan Cox wrote:
> > > Jargon File in all its glory. And if you still think you could look for
> > > patterns, how about executable code that self-modifies in random ways
> > > but when executed as a whole actually has the functionality of fetchmail
> > > embedded within it? How would you guard against that?
> > 
> > Thats a problem for whoever writes the ESR detection tool and to what
> > level it works. The question for the kernel is how do we provide a
> > mechanism to allow (to some extent at least) this kind of tool to run.
> 
> Right. I'm just saying reading a single page out of context (no pun
> intended) is not going to be very useful. 

Fortunately for all concerned, although Alan's self-modifying code is indeed a
possibility, it's much less of an issue than the sort of malware that can be
found with a simple "find this 27-byte sequence, which will be found in either
block 36 or 37 of the file".

And I'll make the prediction that we won't see anything doing the sorts of
things that Alan's program does, until that's the *easiest* way to get into
a system.  Until that time, they're either going to be sending simpler stuff
that a scanner can easily template and find, or using other means of attacks
that are outside the scope of a scanner.

Remember guys - we want to think about *realistic* threat models.  The e-mail
virus scanners we use catch hundreds to thousands of known viruses *every day*.
But I can count on the fingers of both hands the number of times I've had to
deal with a *real* "0-day" in a quarter century.  The scanner doesn't have to
be perfect - it just has to make it hard enough to bypass to render it
economically infeasible.  If you're targeted by a military/govt/political/
religious group that doesn't *care* if it's economically viable, you have
other, bigger problems to deal with...


--==_Exmh_1196403614_4697P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHT6uecC3lWbTT17ARAvIsAKDtic5+YdQSA1dbQb93I5DJxn29CwCg9xaR
6GynIdXXBF6P3AydvZSXiMM=
=Unye
-----END PGP SIGNATURE-----

--==_Exmh_1196403614_4697P--
