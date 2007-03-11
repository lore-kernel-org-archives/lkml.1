Return-Path: <linux-kernel-owner+w=401wt.eu-S933584AbXCKWcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584AbXCKWcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 18:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933595AbXCKWcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 18:32:48 -0400
Received: from h80ad275d.async.vt.edu ([128.173.39.93]:52199 "EHLO
	h80ad275d.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbXCKWcr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 18:32:47 -0400
Message-Id: <200703112232.l2BMWbAI010768@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Moore <eric.moore@lsi.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] MPT FUSION: Delete unused header files.
In-Reply-To: Your message of "Sun, 11 Mar 2007 13:55:54 MDT."
             <20070311195553.GA12056@lsil.com>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0703101656150.28403@CPE00045a9c397f-CM001225dbafb6>
            <20070311195553.GA12056@lsil.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1173652357_8163P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Mar 2007 18:32:37 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1173652357_8163P
Content-Type: text/plain; charset=us-ascii

On Sun, 11 Mar 2007 13:55:54 MDT, Eric Moore said:
>
> With respect to mpi_log_fc.h - this defines the loginfo for fibre channel
> protocal.  This is a easy lookup to for LSI Logic customers to better
> understand the kind of errors returned from firmware, and help reduce number
> of support generated request, as the end user can merely lookup the unqiue
> id in the header file.

Certainly appropriate content for something on your website, and vendors who
provide programs like dmidecode and parsemce are always welcome. I could
probably be convinced that such info should have at least a pointer somewhere
in Documentation/lsi_debug.txt or some such.  But quite frankly, if I'm reduced
to wading through *.h files to figure out what some recalcitrant hardware is
upset about, there's been a failure in documentation.  *ESPECIALLY* if I
go look at drivers/whatever/source.c and it doesn't even *reference* the *.h
file in question.

>                        mpi_inb.h, is header for fibre channel protocal
> ng the inband-management interface, and maybe implemented some day.

Feel free to include mpi_inb.h when you submit the interface for merging.

--==_Exmh_1173652357_8163P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFF9IOFcC3lWbTT17ARAjw/AJ9DYWmrNYvrBkMIY5qVgeJsp4ErKACgslpd
16gp+1PsSJ1YLB1kVCMWp0k=
=Wwim
-----END PGP SIGNATURE-----

--==_Exmh_1173652357_8163P--
