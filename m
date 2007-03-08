Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbXCHU2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbXCHU2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXCHU2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:28:25 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49702 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305AbXCHU2X (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:28:23 -0500
Message-Id: <200703082027.l28KRi4I022669@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc3-mm1
In-Reply-To: Your message of "Thu, 08 Mar 2007 13:34:04 EST."
             <20070308183404.GC5323@tuxdriver.com>
From: Valdis.Kletnieks@vt.edu
References: <20070307201839.6f45735b.akpm@linux-foundation.org> <200703081756.l28HuwDD016018@turing-police.cc.vt.edu>
            <20070308183404.GC5323@tuxdriver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173385664_10421P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Mar 2007 15:27:44 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173385664_10421P
Content-Type: text/plain; charset=us-ascii

On Thu, 08 Mar 2007 13:34:04 EST, "John W. Linville" said:
> On Thu, Mar 08, 2007 at 12:56:58PM -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 07 Mar 2007 20:18:39 PST, Andrew Morton said:
> > >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc3/2.6.21-rc3-mm1/
> > 
> > Mostly working for me.
> > 
> > > - The wireless changes in here need a lot of testers, please.  It is major
> > >   rework.
> > 
> > Working on it - the new MAC80211 stack landed in the -mm tree, but the matching
> > iwlwifi driver for the Intel 3945ABG is still out-of-tree and acting wonky
> > for me.  The card comes up, 'iwlist scanning' sees 4 access points, but it
> > won't associate.  Not sure what I borked up.
> 
> FWIW, I have had best results w/ that driver by manually selecting
> the freq and ap as well as essid.

Confirmed - if I used 'iwconfig ap <mac address> channel <n>' to match something
I found via 'iwlist scan', it was able to associate and connect.

--==_Exmh_1173385664_10421P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF8HHAcC3lWbTT17ARAnmeAKCwMkLNVC4+wNO34+Fc+f60DamYewCfatD5
ryfeYvQ4MDK16Ww9fJhEtlQ=
=71vx
-----END PGP SIGNATURE-----

--==_Exmh_1173385664_10421P--
