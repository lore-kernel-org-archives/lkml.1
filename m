Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZBCD6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZBCD6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZBCD6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:58:06 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34359 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZBCD6F (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:58:05 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or synchronizing threads on different cores
In-Reply-To: Your message of "Mon, 02 Feb 2009 08:43:55 +0100."
             <1233560635.4126.18.camel@localhost.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <bug-12562-10286@http.bugzilla.kernel.org/> <20090128125604.94ed3fe0.akpm@linux-foundation.org> <1233181507.6988.14.camel@bugs-laptop> <1233220048.7835.19.camel@twins> <1233223979.5294.41.camel@bugs-laptop> <1233224644.5294.52.camel@bugs-laptop> <1233229028.4495.34.camel@laptop> <1233237934.11129.183.camel@bugs-laptop> <1233302270.6061.9.camel@marge.simson.net>
            <1233560635.4126.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1233633409_15229P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 02 Feb 2009 22:56:49 -0500
Message-ID: <51126.1233633409@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1233633409_15229P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Feb 2009 08:43:55 +0100, Thomas Pilarski said:
> Am Freitag, den 30.01.2009, 08:57 +0100 schrieb Mike Galbraith:
> > One of those "don't _ever_ do that" things?
> 
> I did not known random() uses a system call. It's rather unrealistic to
> have five million system calls in a second. By adding a small loop with
> some calculations near the random, the problem disappears too.
> It is a unlucky chosen data generator.

Am I the only one that's scared by the concept of anything that beats
on random numbers enough to need 5 million of them a second, but is still
using the relatively sucky one that's in most glibc's? :) 


--==_Exmh_1233633409_15229P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJh8CBcC3lWbTT17ARAr6hAKCQJHMNavoaHrU2VP7h/wBvmiQ1gwCfbCon
vux39H6Al4XRlWu3etGBPKY=
=G8RB
-----END PGP SIGNATURE-----

--==_Exmh_1233633409_15229P--
