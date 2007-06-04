Return-Path: <linux-kernel-owner+w=401wt.eu-S1759298AbXFDRz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298AbXFDRz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758673AbXFDRzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:55:10 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38243 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758127AbXFDRzI (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:55:08 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Randy Dunlap <rdunlap@xenotime.net>, Al Viro <viro@ftp.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
In-Reply-To: Your message of "Mon, 04 Jun 2007 10:43:51 PDT."
             <46644F57.80005@zytor.com>
From: Valdis.Kletnieks@vt.edu
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <46644B97.2010506@zytor.com> <Pine.LNX.4.61.0706041935290.20829@yvahk01.tjqt.qr>
            <46644F57.80005@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180979670_7893P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 04 Jun 2007 13:54:30 -0400
Message-ID: <10880.1180979670@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180979670_7893P
Content-Type: text/plain; charset=us-ascii

On Mon, 04 Jun 2007 10:43:51 PDT, "H. Peter Anvin" said:
> Jan Engelhardt wrote:
> > But gotos are special. ("Evil" minus the "it's good for unrolling in case of an
> > error" case).

> So?
> 
> You still want them to be associated with the level the bailout happens at.

No, you want them associated with the level you bail out *TO*.  Otherwise you
get this:

	...
	...
	if (..) {
		if (..) {
			goto ka_blammo;
	...
	foo = yadda_yadda(.....);
	kfree(bar->some_struct);
			ka_blammo:
	/* continue with cleanup here */

Goto labels belong in column 1.  Or 2 if you believe in the existence of 'diff
-p' that get confused by col-1 labels.


--==_Exmh_1180979670_7893P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGZFHWcC3lWbTT17ARAnxjAJ93+rpXQcVSoMKvN2wPIryrWUATJgCffoJ9
9lpE5rSOuLQpjbFNExdJ1is=
=ihTm
-----END PGP SIGNATURE-----

--==_Exmh_1180979670_7893P--
