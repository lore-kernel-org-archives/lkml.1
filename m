Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbZGBU1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbZGBU1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 16:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZGBU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 16:27:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58097 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbZGBU1c (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 16:27:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: mmotm 2009-06-30-12-50 uploaded
In-Reply-To: Your message of "Thu, 02 Jul 2009 12:47:26 PDT."
             <20090702124726.a253f13d.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <6719.1246562163@turing-police.cc.vt.edu>
            <20090702124726.a253f13d.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246566065_2896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 02 Jul 2009 16:21:05 -0400
Message-ID: <30563.1246566065@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246566065_2896P
Content-Type: text/plain; charset=us-ascii

On Thu, 02 Jul 2009 12:47:26 PDT, Andrew Morton said:

> apart from having a crappy title, linux-next's
> 
> : commit f29876421ec11f7d66f3d982219ef3af9bcccf32
> : Author: Rusty Russell <rusty@rustcorp.com.au>
> : AuthorDate: Wed Jul 1 12:37:19 2009 +1000
> : Commit: Stephen Rothwell <sfr@canb.auug.org.au>
> : CommitDate: Wed Jul 1 12:37:19 2009 +1000
> :
> : misc:work_on_cpu-acpi
> :
> 
> causes get_throttling() to newly be called from an IPI, and lockdep doesn't
> like irq-disabled interrupt handlers doing local_irq_enable().
> 
> 
> If we rely upon these functions only ever being called from
> smp_call_function_single(), and if smp_call_function_single() is
> correctly implemented, we should be able to do this:

I'll take a leap of faith on the "correctly implemented" part.  However,
I admit I'm probably going to wait till Len or somebody agrees on the
"only calledf from function_single()" part being correct before test-driving
the patch...

--==_Exmh_1246566065_2896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKTRawcC3lWbTT17ARAgmuAKDOIPw0qPP+dy8JuCOIeZIjcSmSqgCgsmUz
W89Q9WCP0/Y4GWyAnRtuzDQ=
=QuBg
-----END PGP SIGNATURE-----

--==_Exmh_1246566065_2896P--
