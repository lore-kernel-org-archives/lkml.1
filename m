Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbXITOTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbXITOTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXITOTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:19:05 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:52731 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbXITOTE (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:19:04 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Wed, 19 Sep 2007 22:47:41 +0200."
             <46F18AED.4090906@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org> <46F17F27.5080000@gmail.com> <12009.1190233975@turing-police.cc.vt.edu>
            <46F18AED.4090906@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190294255_2939P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Sep 2007 09:17:35 -0400
Message-ID: <21897.1190294255@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190294255_2939P
Content-Type: text/plain; charset=us-ascii

On Wed, 19 Sep 2007 22:47:41 +0200, Jiri Slaby said:
> On 09/19/2007 10:32 PM, Valdis.Kletnieks@vt.edu wrote:

> > That would probably have been me, saying that x86_64-mm-cpa-clflush.patch broke
> > the NVidia graphics driver in 23-rc3-mm1.  Is it breaking *other* X drivers as
> > well?
> 
> Yes, the issue is there from rc3-mm1, see (intel and radeon cards are affected
> in my case):
> http://lkml.org/lkml/2007/9/9/51
> 
> But now I'm talking about another issue -- a regression since rc4-mm1, where X
> server is unable to bind agp memory (those x logs above). The clflush issue has
> solved andi in
> http://lkml.org/lkml/2007/9/19/334
> recently

Tried that, my laptop still bricks the instant X starts up and the NVidia driver
tries to initialize.  Not even sysrq-foo works. Time to power-cycle.

--==_Exmh_1190294255_2939P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8nLvcC3lWbTT17ARAsgcAJ9NP7K5n82zHlXdqwKwuNjXj/fcqQCg+TJi
tsiagr4N8kYJJHG8pGMmwLM=
=IYLE
-----END PGP SIGNATURE-----

--==_Exmh_1190294255_2939P--
