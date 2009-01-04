Return-Path: <linux-kernel-owner+w=401wt.eu-S1755741AbZADFIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741AbZADFIV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 00:08:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbZADFIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 00:08:07 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55476 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZADFIG (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 00:08:06 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Rob Landley <rob@landley.net>
Cc: Ingo Oeser <ioe-lkml@rameria.de>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
In-Reply-To: Your message of "Sat, 03 Jan 2009 19:36:04 CST."
             <200901031936.04642.rob@landley.net>
From: Valdis.Kletnieks@vt.edu
References: <200901020207.30359.rob@landley.net> <200901020213.30658.rob@landley.net> <200901031328.23079.ioe-lkml@rameria.de>
            <200901031936.04642.rob@landley.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231045675_3941P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 04 Jan 2009 00:07:55 -0500
Message-ID: <25035.1231045675@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231045675_3941P
Content-Type: text/plain; charset=us-ascii

On Sat, 03 Jan 2009 19:36:04 CST, Rob Landley said:
> On Saturday 03 January 2009 06:28:22 Ingo Oeser wrote:
> > > +for i in "MSEC 1000" "USEC 1000000"
> > > +do
> > > +	NAME=$(echo $i | awk '{print $1}')
> >
> > cut -d' ' -f1  does the same
> >
> > > +	PERIOD=$(echo $i | awk '{print $2}')
> >
> > cut -d' ' -f2  does the same

Close, but no cee-gar.  cut does something counter-intuitive with multiple
blanks:

% echo 'a    b' | awk '{print $2}'
b
% echo 'a    b' | cut -d' ' -f2

% echo 'a    b' | sed -r 's/[ ]+/ /g' | cut -d' ' -f2
b

Unfortunately, 'sed -r' isn't in the opengroup.org list of required options,
and sed 's/  / /g' doesn't DTRT for 3 or more blanks (as it won't recursively
apply the change to a *new* double blank formed by the previous change).


--==_Exmh_1231045675_3941P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJYEQrcC3lWbTT17ARAjSfAJsFWvd16dO8/vFBSogpBUGHIGVVuQCdGYxs
DB0Qw6+Ms3XwxrCB1klRqyo=
=Eg7u
-----END PGP SIGNATURE-----

--==_Exmh_1231045675_3941P--
