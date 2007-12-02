Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbXLBVKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbXLBVKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 16:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752621AbXLBVKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 16:10:04 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40993 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXLBVKD (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 16:10:03 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Pavel Machek <pavel@ucw.cz>
Cc: tvrtko.ursulin@sophos.com, Andi Kleen <andi@firstfloor.org>, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: Your message of "Sun, 02 Dec 2007 21:22:40 +0100."
             <20071202202240.GB1625@elf.ucw.cz>
From: Valdis.Kletnieks@vt.edu
References: <p738x4i9nyd.fsf@crumb.suse.de> <OFFB86F10D.D565B603-ON802573A2.005A558C-802573A2.005B85B0@sophos.com> <20071201084332.GB4446@ucw.cz> <17957.1196624688@turing-police.cc.vt.edu>
            <20071202202240.GB1625@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196629795_2962P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 02 Dec 2007 16:09:55 -0500
Message-ID: <23463.1196629795@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196629795_2962P
Content-Type: text/plain; charset=us-ascii

On Sun, 02 Dec 2007 21:22:40 +0100, Pavel Machek said:
> Well, if you only want to detect viruses _sometimes_, you can just
> LD_PRELOAD your scanner.

And for some use cases, that probably *is* the best answer..

> I guess the A/V people should describe what they are trying to do, as
> in
> 
> "forbidden sequences of bits should never hit disk" or "forbidden
> sequences of bits should be never read from disk"  or something...

We probably want to hear related usages as well - what *besides* A/V would be
interested? Indexing services?  Software that tries to limit the distribution
of sensitive info off the machine - for instance, imagine a rule that said
"Data that comes from a file that contains SSNs or the string 'Corporate
Secret' data isn't allowed to leave the computer" and a Perl-like 'taint'
concept.  I'm not saying its *doable*, but it's certainly a goal that somebody
would like to achieve...


--==_Exmh_1196629795_2962P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHUx8jcC3lWbTT17ARAgb8AJ4yZYMxXoicZEXNGbB/dtr5zH8/VACgyuGh
ButXpSLhoAHF8+XnQy55t58=
=/HB+
-----END PGP SIGNATURE-----

--==_Exmh_1196629795_2962P--
