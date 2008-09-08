Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbYIHU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbYIHU0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYIHU0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:26:07 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:34364 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbYIHU0G (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:26:06 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
In-Reply-To: Your message of "Mon, 08 Sep 2008 21:02:49 +0200."
             <20080908190249.GA21998@elte.hu>
From: Valdis.Kletnieks@vt.edu
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org> <48C56D60.7010405@zytor.com> <20080908114619.741b6786@infradead.org> <48C57439.3040903@zytor.com>
            <20080908190249.GA21998@elte.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1220905541_3062P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Sep 2008 16:25:41 -0400
Message-ID: <38118.1220905541@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1220905541_3062P
Content-Type: text/plain; charset=us-ascii

On Mon, 08 Sep 2008 21:02:49 +0200, Ingo Molnar said:

> ... and so on it goes with this argument. Everyone has a different 
> target audience and there's no firm limit. Maybe what makes more sense 
> is to have some sort of time dependency:
> 
>   support all x86 CPUs released in the last year
>   support all x86 CPUs released in the past 5 years
>   support all x86 CPUs released in the past 10 years
>   support all x86 CPUs released ever
>   [ ... or configure a specific model ]
> 
> and people/distributions would use _those_ switches. That means we could 
> continuously tweak those targets, as systems become obsolete and new 
> CPUs arrive.

That's just *asking* for flame mail if somebody builds a kernel for a system
that's 4 year 9 months old, and he builds a kernel 6 months later, and it fails
to boot because the CPU is now 3 months out and we've deprecated it...

Quick - what year/month was the CPU you're using now released?  No peeking. ;)

(For the record, I have no *clue* when Intel actually released the Core2 T7200,
which is a whole *nother* can of worms - the chip release date can be quite
some time before the system vendor ships, and when the consumer actually buys
it - it's quite possible that we can write "released in the past 5 years",
a user looks at it and says "I bought this system 4 years 2 months ago", and
think he's OK, but he's not because he bought a system released 4 years 9 months
ago that used a chipset released 5 years 6 months ago...

--==_Exmh_1220905541_3062P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIxYpFcC3lWbTT17ARApiwAJ4xiuWdeenfwT+PR54drwpmcUTMcwCfVvOj
5vu7RYS0y5KyTkI9P+GNROA=
=2l6d
-----END PGP SIGNATURE-----

--==_Exmh_1220905541_3062P--
