Return-Path: <linux-kernel-owner+w=401wt.eu-S1751951AbXDDWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbXDDWgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 18:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXDDWgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 18:36:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:38720 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbXDDWgt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 18:36:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: per-thread rusage
In-Reply-To: Your message of "Wed, 04 Apr 2007 10:29:31 PDT."
             <20070404172931.GM2986@holomorphy.com>
From: Valdis.Kletnieks@vt.edu
References: <20070404172931.GM2986@holomorphy.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175726207_4061P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 18:36:47 -0400
Message-ID: <7653.1175726207@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175726207_4061P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Apr 2007 10:29:31 PDT, William Lee Irwin III said:

> Index: anon/include/linux/resource.h
> ===================================================================
> --- anon.orig/include/linux/resource.h	2007-04-04 09:57:41.239118534 -
0700
> +++ anon/include/linux/resource.h	2007-04-04 09:57:59.840178548 -0700
> @@ -18,7 +18,8 @@
>   */
>  #define	RUSAGE_SELF	0
>  #define	RUSAGE_CHILDREN	(-1)
> -#define RUSAGE_BOTH	(-2)		/* sys_wait4() uses this */
> +#define RUSAGE_THREAD	(-2)
> +#define RUSAGE_BOTH	(-3)		/* sys_wait4() uses this */

Umm.. I'm having a high-idiot-quotient day today, but don't you want to
leave _BOTH at -2 and put _THREAD at -3, to avoid an ABI breakage?

--==_Exmh_1175726207_4061P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFCh/cC3lWbTT17ARAre1AKD5Z6TOf6D9soCDdZr77xd9CQPesgCdEGVa
81UZJ9a42A6o5Oj1xxlGg5s=
=/ZeH
-----END PGP SIGNATURE-----

--==_Exmh_1175726207_4061P--
