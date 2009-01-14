Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZANT33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZANT33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 14:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754980AbZANT3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 14:29:21 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55087 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZANT3U (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 14:29:20 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Takashi Iwai <tiwai@suse.de>
Cc: Kyle McMartin <kyle@infradead.org>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: kzalloc mod->ref
In-Reply-To: Your message of "Wed, 14 Jan 2009 17:25:31 +0100."
             <s5hiqoh7t38.wl%tiwai@suse.de>
From: Valdis.Kletnieks@vt.edu
References: <20090114033533.GL25103@bombadil.infradead.org> <s5hmydufe3c.wl%tiwai@suse.de> <20090114155859.GO25103@bombadil.infradead.org>
            <s5hiqoh7t38.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231961348_3678P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Jan 2009 14:29:08 -0500
Message-ID: <24465.1231961348@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231961348_3678P
Content-Type: text/plain; charset=us-ascii

On Wed, 14 Jan 2009 17:25:31 +0100, Takashi Iwai said:

> We can use nr_cpu_ids instead of NR_CPUS.
> For a machine like 4096 CPUs, such an amount of memory is like a
> peanut :)

It's not peanuts if you're dealing with a distro kernel that's essentially
forced to compile with NR_CPUS=<some moby integer>, but booting on a single or
dual core system with possibly not even 1G of memory.


--==_Exmh_1231961348_3678P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJbj0EcC3lWbTT17ARAjA5AKCGpPk6L06dSDQK7283sGm2i7YTLgCfZSvP
AHb7j/86QaqZAQZo2SsqpVY=
=ieFn
-----END PGP SIGNATURE-----

--==_Exmh_1231961348_3678P--
