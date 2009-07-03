Return-Path: <linux-kernel-owner+w=401wt.eu-S1756996AbZGCK0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbZGCK0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbZGCK0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:26:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:54031 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbZGCK0b (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:26:31 -0400
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
Content-Type: multipart/signed; boundary="==_Exmh_1246616732_3932P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 03 Jul 2009 06:25:32 -0400
Message-ID: <4976.1246616732@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246616732_3932P
Content-Type: text/plain; charset=us-ascii

On Thu, 02 Jul 2009 12:47:26 PDT, Andrew Morton said:
> On Thu, 02 Jul 2009 15:16:03 -0400
> Valdis.Kletnieks@vt.edu wrote:

> > [    0.657296] WARNING: at kernel/lockdep.c:2143 trace_hardirqs_on_caller+0xc7/0x145()

> If we rely upon these functions only ever being called from
> smp_call_function_single(), and if smp_call_function_single() is
> correctly implemented, we should be able to do this:
> 
> --- a/drivers/acpi/processor_throttling.c~a
> +++ a/drivers/acpi/processor_throttling.c

That does seem to have scared the warning into hiding - I'm not seeing it
anymore in -mmotm0702.  Thanks.

--==_Exmh_1246616732_3932P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKTdyccC3lWbTT17ARAmT+AJ9Zv5DmWAwaksXGGv1IrEJfclggnACffRiu
5mrBVYsS/ygV2OtLYCQBFhM=
=eH/4
-----END PGP SIGNATURE-----

--==_Exmh_1246616732_3932P--
