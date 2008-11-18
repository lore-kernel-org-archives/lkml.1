Return-Path: <linux-kernel-owner+w=401wt.eu-S1752136AbYKRChE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbYKRChE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 21:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbYKRCgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 21:36:51 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52486 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbYKRCgu (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 21:36:50 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: 2.6.28-rc4-mmotm1110 shift-lock oddness
In-Reply-To: Your message of "Tue, 18 Nov 2008 01:26:51 +0100."
             <alpine.LRH.1.10.0811180125150.3104@twin.jikos.cz>
From: Valdis.Kletnieks@vt.edu
References: <5397.1226959015@turing-police.cc.vt.edu> <20081117162350.82b2806b.akpm@linux-foundation.org>
            <alpine.LRH.1.10.0811180125150.3104@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226975771_3596P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Nov 2008 21:36:11 -0500
Message-ID: <18584.1226975771@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226975771_3596P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <18571.1226975763.1@turing-police.cc.vt.edu>

On Tue, 18 Nov 2008 01:26:51 +0100, Jiri Kosina said:

> First, we'd need a little bit more information about the hardware in 
> question, I guess.

Dell Latitude D820 laptop, with a USB-connected Microsoft Natural keyboard. I
don't think it's the USB subsystem going *completely* bonkers, as the
USB-connected trackball mouse functions just fine when this happens...

> What laptop is that, please? Is the keyboard PS/2-connected or 
> USB-connected? Could you obtain evtest output from the buggy cases please?

Hmm.. Got a pointer to a usable copy? The best I could find googling for
'linux evtest' was:

https://svn.openwrt.org/openwrt/packages/utils/event_test/src/evtest.c

which wants a /dev/inputN - all I have is /dev/input/ and entries under that
for the laptop's onboard mousepad and the trackball mouse, no keyboard entry.

Hmm part two:

% zgrep EVDEV /proc/config.gz 
# CONFIG_INPUT_EVDEV is not set

Should I be looking at rebuilding the kernel with this =m?



--==_Exmh_1226975771_3596P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJIiobcC3lWbTT17ARAoF3AKDWEWC4gQ3o6lAtJWZjtlgf/H7PoACeO9ii
+jOKsVSxWbSp8Bqc+FqissQ=
=Ctug
-----END PGP SIGNATURE-----

--==_Exmh_1226975771_3596P--
