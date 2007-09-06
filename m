Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbXIFOLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbXIFOLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 10:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbXIFOLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 10:11:01 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34634 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbXIFOLB (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 10:11:01 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1 - git-alsa.patch breaks audio on Dell Latitude D820
In-Reply-To: Your message of "Wed, 05 Sep 2007 23:39:45 +0200."
             <s5hlkbkx04e.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <4658.1189021594@turing-police.cc.vt.edu> <s5hir6orhxz.wl%tiwai@suse.de> <s5hfy1srh6w.wl%tiwai@suse.de> <3705.1189027009@turing-police.cc.vt.edu>
            <s5hlkbkx04e.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189087854_2844P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 06 Sep 2007 10:10:54 -0400
Message-ID: <21226.1189087854@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189087854_2844P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Sep 2007 23:39:45 +0200, Takashi Iwai said:
> At Wed, 05 Sep 2007 17:16:49 -0400, Valdis.Kletnieks@vt.edu wrote:
> > modprobe snd_hda_intel model=dell-m23 
> > 
> > was the magic incantation.  I'm sure that every user who trips over this
> > is going to call it a regression, since the -rc3-mm1 module was able to
> > get it right without hints. ;)
> 
> Well, it's indeed a regression.  There seems to be mistakes in the pin
> configuration orders. 
> 
> Could you try the patch below (without model option)?

That patch makes it work as expected, at least on my Dell.  Do we need to
find testers for the other 9 varieties of Dell Sigmatel chipsets, or was it
the same basic error on all 10, so if it works on one it should be OK for
the others?


--==_Exmh_1189087854_2844P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG4ApucC3lWbTT17ARAnKTAJ0VdlR9IZBj2JrqZsCQrXu7YzaZ9ACg6T+8
g4VZIlmI0N68vhvhitH/YOg=
=tToF
-----END PGP SIGNATURE-----

--==_Exmh_1189087854_2844P--
