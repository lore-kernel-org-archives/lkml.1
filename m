Return-Path: <linux-kernel-owner+w=401wt.eu-S1755861AbYHHDjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861AbYHHDjl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 23:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYHHDje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 23:39:34 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55414 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYHHDjd (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 23:39:33 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: g3vbv@blueyonder.co.uk
Cc: linux-kernel@vger.kernel.org
Subject: Re: A question regarding init_mm
In-Reply-To: Your message of "Fri, 08 Aug 2008 02:49:29 BST."
             <489BA629.4030008@blueyonder.co.uk>
From: Valdis.Kletnieks@vt.edu
References: <489BA629.4030008@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1218166771_9292P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 07 Aug 2008 23:39:32 -0400
Message-ID: <71281.1218166772@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1218166771_9292P
Content-Type: text/plain; charset=us-ascii

On Fri, 08 Aug 2008 02:49:29 BST, Sid Boyce said:

> EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
 
> Any thoughts on why it's not seen? No one on the nvidia list has a clue 
> either.

Run a kernel built with 'CONFIG_UNUSED_SYMBOLS=y', that should help matters
somewhat.

The *real* problem is that the NVidia driver uses the deprecated pgd_offset_k()
function (see NV_PGD_OFFSET in lv-linux.h).  That's what needs fixing.

--==_Exmh_1218166771_9292P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIm7/zcC3lWbTT17ARAnm1AKCfnSy4YKBpnkMx7tuAYM5bnyEuwwCglc77
Dyxmx9fMODt2FydRzXZj1X8=
=ZOKG
-----END PGP SIGNATURE-----

--==_Exmh_1218166771_9292P--
