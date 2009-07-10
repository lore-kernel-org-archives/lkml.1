Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZGJUZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZGJUZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756262AbZGJUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:25:21 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:57788 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099AbZGJUZT (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:25:19 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andrew Morton <akpm@linux-foundation.org>, oleg@redhat.com,
       mingo@elte.hu, tony.luck@intel.com, rth@twiddle.net,
       geert@linux-m68k.org
Subject: Re: [PATCH 1/2] sched: INIT_PREEMPT_COUNT
In-Reply-To: Your message of "Fri, 10 Jul 2009 17:51:06 +0200."
             <1247241066.7529.50.camel@twins>
From: Valdis.Kletnieks@vt.edu
References: <20090710125755.559739294@chello.nl> <20090710130125.037018244@chello.nl> <17047.1247240546@turing-police.cc.vt.edu>
            <1247241066.7529.50.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1247257453_3858P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 10 Jul 2009 16:24:13 -0400
Message-ID: <47357.1247257453@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1247257453_3858P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Jul 2009 17:51:06 +0200, Peter Zijlstra said:

> Something along the lines of the below?
> 
> ---
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -502,7 +502,9 @@ struct task_cputime {
>  
>  /*
>   * Disable preemption until the scheduler is running.
> - * Reset by start_kernel()->sched_init()->init_idle().
> + *
> + * We reset this initial offset of init_thread_info.preempt_count in:
> + *     start_kernel()->sched_init()->init_idle().
>   */
>  #define INIT_PREEMPT_COUNT	(1)

Works for me, thanks...

--==_Exmh_1247257453_3858P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKV6NtcC3lWbTT17ARAmvFAJ4nO7b0ABq9AyeGxd6WenWLuIf2fQCg0Fwh
r0VnakKSjRIusnawKBOjLho=
=NwLF
-----END PGP SIGNATURE-----

--==_Exmh_1247257453_3858P--
