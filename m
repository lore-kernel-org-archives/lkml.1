Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXIETzN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXIETzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:55:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbXIETzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:55:00 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41702 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbXIETy7 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:54:59 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc4-mm1 - git-alsa.patch breaks audio on Dell Latitude D820
In-Reply-To: Your message of "Wed, 05 Sep 2007 15:46:34 EDT."
             <4658.1189021594@turing-police.cc.vt.edu>
From: Valdis.Kletnieks@vt.edu
References: <20070831215822.26e1432b.akpm@linux-foundation.org>
            <4658.1189021594@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1189022095_2892P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Sep 2007 15:54:55 -0400
Message-ID: <5129.1189022095@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1189022095_2892P
Content-Type: text/plain; charset=us-ascii

On Wed, 05 Sep 2007 15:46:34 EDT, Valdis.Kletnieks@vt.edu said:
>
> % grep HDA_ .config
> CONFIG_SND_HDA_INTEL=y
> # CONFIG_SND_HDA_HWDEP is not set
> CONFIG_SND_HDA_CODEC_REALTEK=y
> CONFIG_SND_HDA_CODEC_ANALOG=y
> CONFIG_SND_HDA_CODEC_SIGMATEL=y
> # CONFIG_SND_HDA_CODEC_VIA is not set
> # CONFIG_SND_HDA_CODEC_ATIHDMI is not set
> # CONFIG_SND_HDA_CODEC_CONEXANT is not set
> # CONFIG_SND_HDA_CODEC_CMEDIA is not set
> # CONFIG_SND_HDA_CODEC_SI3054 is not set
> CONFIG_SND_HDA_GENERIC=y
> # CONFIG_SND_HDA_POWER_SAVE is not set

For the record, REALTEK and ANALOG got set to Y in my bisect build because of
the infamous "defaults to Y" syndrome - after I saw Sigmatel go by I wised up
and started saying N, but forgot to clean up the first two.  Those two are
disabled in the live -rc4-mm1 .config, and it has the same issue.


--==_Exmh_1189022095_2892P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG3wmPcC3lWbTT17ARAvLjAKDaR06Tk5ZJXo/58wKecUNaZ7WOCQCg+bGU
mQfvcnspYDR1ccG1oVqGQBU=
=4RWd
-----END PGP SIGNATURE-----

--==_Exmh_1189022095_2892P--
