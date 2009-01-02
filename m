Return-Path: <linux-kernel-owner+w=401wt.eu-S1756945AbZABCmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945AbZABCmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZABCmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:42:11 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51454 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbZABCmK (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:42:10 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-12-30-16-05 uploaded
In-Reply-To: Your message of "Thu, 01 Jan 2009 18:31:57 PST."
             <20090101183157.dfbe9789.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org> <22921.1230843108@turing-police.cc.vt.edu>
            <20090101183157.dfbe9789.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1230864125_3311P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 01 Jan 2009 21:42:05 -0500
Message-ID: <18080.1230864125@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1230864125_3311P
Content-Type: text/plain; charset=us-ascii

On Thu, 01 Jan 2009 18:31:57 PST, Andrew Morton said:
> On Thu, 01 Jan 2009 15:51:48 -0500 Valdis.Kletnieks@vt.edu wrote:
> 
> > On Tue, 30 Dec 2008 16:06:00 PST, akpm@linux-foundation.org said:
> > > The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to
> > 
> > 
> >   CC =5BM=5D  drivers/misc/dell-laptop.o
> > drivers/misc/dell-laptop.c: In function dell_send_request:
> > drivers/misc/dell-laptop.c:147: error: implicit declaration of function dcdbas_smi_request
> > 
> > Fix: move misc-add-dell-laptop-driver.patch to someplace below
> > dcdbas-export-functionality-for-use-in-other-drivers.patch in the series file.
> > 
> 
> OK, thanks, done.
> 
> Confused.  I assume you were doing a bisection.

Yeah, I got a kernel that died very early - no early_printk, no penguin logos,
nada.  Turned out to be self-inflicted.

--==_Exmh_1230864125_3311P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJXX79cC3lWbTT17ARAnSyAKCa6wK6YW9wq6eWpyUuCwUa0yIFmQCdH5OA
5r6eBWj6vRPUOAEESesAzyU=
=JXRG
-----END PGP SIGNATURE-----

--==_Exmh_1230864125_3311P--
