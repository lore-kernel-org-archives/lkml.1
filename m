Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbXLFUFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbXLFUFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 15:05:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbXLFUE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 15:04:56 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:45092 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbXLFUEz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 15:04:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: 2.6.24-rc4-mm1
In-Reply-To: Your message of "Thu, 06 Dec 2007 11:38:43 PST."
             <20071206193843.GA25125@kroah.com>
From: Valdis.Kletnieks@vt.edu
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <3941.1196941764@turing-police.cc.vt.edu> <20071206040420.6c89c675.akpm@linux-foundation.org> <4374.1196968688@turing-police.cc.vt.edu>
            <20071206193843.GA25125@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196971465_2829P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Dec 2007 15:04:25 -0500
Message-ID: <7466.1196971465@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196971465_2829P
Content-Type: text/plain; charset=us-ascii

On Thu, 06 Dec 2007 11:38:43 PST, Greg KH said:
> > Would I be remiss in hypothesising that something in gregkh-driver-kobject-*
> > changed something, and now we need a agk-dm-dm-kobject-fixupage.patch?
> 
> I don't know, it all depends on what is in the dm patches.  Hopefully
> everything that I have changed will manifest with a build breakage to
> obviously detect that something needs to be fixed up.
> 
> But I've been known to mess things up that I didn't intend to :)

Given that it *didn't* totally break the build, it's likely a fencepost error
or some similar issue...

> If there's anything that I can do to test this, please let me know.

I wanted to give a heads-up, in case there was a D'Oh! patch hiding. At worst,
I just need another 6 or 7 bisects to figure out which of those 120-ish patches
is the culprit.  With luck I'll end up stopped on a patch that in retrospect
was obviously busticated.  If not, we'll have to apply the usual more drastic
measures.  If you don't have a box that's already demonstrating it, and you
don't have any obvious candidates, it's likely that the most productive
use of everybody's time is for you to chase down any other kobject issues
while I bisect the problem down further...

--==_Exmh_1196971465_2829P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHWFXJcC3lWbTT17ARApgEAJ9pJDSM7zZqycRF0neS4dgz9JOnAgCfUyh8
MgzWo8mGixxHoRSnzFCNNh0=
=TOhE
-----END PGP SIGNATURE-----

--==_Exmh_1196971465_2829P--
