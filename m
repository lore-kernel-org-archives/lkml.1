Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbXLBTsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbXLBTsJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbXLBTr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:47:57 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57829 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbXLBTr4 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:47:56 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Christer Weinigel <christer@weinigel.se>
Cc: Andy Whitcroft <apw@uk.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] teach checkpatch.pl about list_for_each
In-Reply-To: Your message of "Sun, 02 Dec 2007 13:03:35 +0100."
             <20071202130335.690a8daf@cw05lap>
From: Valdis.Kletnieks@vt.edu
References: <20071202130335.690a8daf@cw05lap>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1196624872_2962P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 02 Dec 2007 14:47:52 -0500
Message-ID: <18063.1196624872@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1196624872_2962P
Content-Type: text/plain; charset=us-ascii

On Sun, 02 Dec 2007 13:03:35 +0100, Christer Weinigel said:

> WARNING: no space between function name and open parenthesis '('
> #520: FILE: drivers/spi/spi_s3c24xx_dma.c:478:
> +       list_for_each_entry (transfer, &message->transfers, transfer_list) {
> 
> which I think is a bit bogus since it actually is a for statement in
> disguise.

That's how it's *implemented*.  I obviously studied too much Lisp as an
undergrad, I keep thinking of list_for_* helpers as functions that take a
lambda-expression as input. In which case, it's a function and no blank is used.

:)

--==_Exmh_1196624872_2962P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHUwvocC3lWbTT17ARAhK9AKD8Tnc4zwhc+rPFzJax0Wt5D+XKeQCgmCbP
6i6jBanz+Ge5p/A0eq61Jeo=
=gmXB
-----END PGP SIGNATURE-----

--==_Exmh_1196624872_2962P--
