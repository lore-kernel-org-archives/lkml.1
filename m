Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbYIRVJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbYIRVJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755245AbYIRVJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:09:43 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:33454 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbYIRVJm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:09:42 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
In-Reply-To: Your message of "Thu, 18 Sep 2008 22:17:22 +0200."
             <s5hk5d9us31.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <s5hbpyny7bl.wl%tiwai@suse.de> <20080918122541.2c3c7b39@areia.chehab.org>
            <s5hk5d9us31.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1221772167_3536P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 18 Sep 2008 17:09:27 -0400
Message-ID: <31195.1221772167@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1221772167_3536P
Content-Type: text/plain; charset=us-ascii

On Thu, 18 Sep 2008 22:17:22 +0200, Takashi Iwai said:

> There are different perspectives for this.  My goal to reduce the
> build time with the existing kernel config for a specific hardware.
> That is, it makes eaiser to create another set of kernel with test
> patches or bisect.

One has to be careful here - I've more than once hit kernel bugs that I ended
up bisecting, which were dependent on the exact .config used.  The most recent
was a deadlock during early boot if CONFIG_HID_COMPAT=y, which would have
been turned off by any sane kconfig trimmer.  On the flip side, running a
trimmer wouldn't minimize my .config very much, because I've already set most
stuff I *never* use to 'n'.

And more than once, I've had a bisect go horribly awry and need to be re-started
because the bisect crossed back and forth over a commit that added a config
option, so doing a 'make oldconfig' at each iteration would re-prompt, and
I wasn't consistent in the reply I gave.  Usually doesn't matter, except when
the broken code is in the support for the feature...

I *do* keep around a *very* minimal "only what I need to get to single-user"
config if build time is an issue...

Might be different if you're starting off with a distro config that's basically
an 'allmodconfig' - lotta fat to trim off *that*....

--==_Exmh_1221772167_3536P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFI0sOHcC3lWbTT17ARAml1AKCQiuV7j5vrhE+S5zRlf3Kfp+cJCQCfdGIm
y269PrKX5kRVLplcyN1ZHIw=
=+NpQ
-----END PGP SIGNATURE-----

--==_Exmh_1221772167_3536P--
