Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbXISUd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbXISUd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 16:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbXISUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 16:33:21 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54123 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbXISUdU (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 16:33:20 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: X-freeze after clflush changes [Was: 2.6.23-rc6-mm1]
In-Reply-To: Your message of "Wed, 19 Sep 2007 21:57:27 +0200."
             <46F17F27.5080000@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20070918011841.2381bd93.akpm@linux-foundation.org> <46F10B69.5070008@gmail.com> <46F10DCB.1090302@gmail.com> <46F13938.1070709@gmail.com> <20070919121017.0cbcbc30.akpm@linux-foundation.org> <20070919192453.GB18707@one.firstfloor.org> <46F17CA1.5080205@gmail.com> <20070919195425.GF18707@one.firstfloor.org>
            <46F17F27.5080000@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190233975_23458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 19 Sep 2007 16:32:55 -0400
Message-ID: <12009.1190233975@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190233975_23458P
Content-Type: text/plain; charset=us-ascii

On Wed, 19 Sep 2007 21:57:27 +0200, Jiri Slaby said:
> On 09/19/2007 09:54 PM, Andi Kleen wrote:
> >> Yeah. (But X doesn't run -- this is maybe the known issue in this release)
.
> > 
> > What do you mean with not run? 
> 
> (II) intel(0): Initializing HW Cursor
> (II) intel(0): xf86BindGARTMemory: bind key 0 at 0x005ff000 (pgoffset 1535)
> (WW) intel(0): xf86BindGARTMemory: binding of gart memory with key 0
>         at offset 0x5ff000 failed (Invalid argument)
> 
> Fatal server error:
> Couldn't bind memory for front buffer
> 
> I thought I'd seen a thread about this issue, but I can't find it now. Is it
> known or am I seeing ghosts yet, Andrew?

That would probably have been me, saying that x86_64-mm-cpa-clflush.patch broke
the NVidia graphics driver in 23-rc3-mm1.  Is it breaking *other* X drivers as
well?


--==_Exmh_1190233975_23458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG8Yd3cC3lWbTT17ARAnCuAJ4waU6Z896nKNSE1Ma6gk7pCaVPUwCfaSps
qtp2z6HDPinJYlQ0rhGzVuw=
=Gxro
-----END PGP SIGNATURE-----

--==_Exmh_1190233975_23458P--
