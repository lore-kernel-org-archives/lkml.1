Return-Path: <linux-kernel-owner+w=401wt.eu-S1757373AbXIEVRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373AbXIEVRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 17:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbXIEVQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 17:16:56 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:35156 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754838AbXIEVQz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 17:16:55 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1 - git-alsa.patch breaks audio on Dell Latitude D820
In-Reply-To: Your message of "Wed, 05 Sep 2007 22:27:35 +0200."
             <s5hfy1srh6w.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <4658.1189021594@turing-police.cc.vt.edu> <s5hir6orhxz.wl%tiwai@suse.de>
            <s5hfy1srh6w.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189027009_2962P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Sep 2007 17:16:49 -0400
Message-ID: <3705.1189027009@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189027009_2962P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Sep 2007 22:27:35 +0200, Takashi Iwai said:

> BTW, there are 10 different models to test for Dell with STAC9200
> (dell-d2[1-3] and dell-m2[1-7], see

modprobe snd_hda_intel model=dell-m23 

was the magic incantation.  I'm sure that every user who trips over this
is going to call it a regression, since the -rc3-mm1 module was able to
get it right without hints. ;)

--==_Exmh_1189027009_2962P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG3xzBcC3lWbTT17ARAi/yAJsF8QoXXwwGuvnUtYr0Pw3O1O/OYQCgkqzR
4TpniAZ4xo0uCbfrEouWBvc=
=+xHB
-----END PGP SIGNATURE-----

--==_Exmh_1189027009_2962P--
