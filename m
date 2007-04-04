Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXDDVzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXDDVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbXDDVzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:55:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53060 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXDDVzr (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:55:47 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Maxim Uvarov <muvarov@ru.mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: Performance Stats: Kernel patch
In-Reply-To: Your message of "Wed, 04 Apr 2007 15:46:24 +0200."
             <20070404154624.826578b1.dada1@cosmosbay.com>
From: Valdis.Kletnieks@vt.edu
References: <46124E93.2000408@ru.mvista.com> <16797.1175641303@turing-police.cc.vt.edu> <4613A4FF.9030202@ru.mvista.com>
            <20070404154624.826578b1.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175723672_4061P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Apr 2007 17:54:32 -0400
Message-ID: <6284.1175723672@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175723672_4061P
Content-Type: text/plain; charset=us-ascii

On Wed, 04 Apr 2007 15:46:24 +0200, Eric Dumazet said:
> On Wed, 04 Apr 2007 17:15:43 +0400
> Maxim Uvarov <muvarov@ru.mvista.com> wrote:

> > +#ifdef CONFIG_THREAD_PERF_STAT_SYSC
> > +       call inc_syscallcnt             # Increment syscalls counter 
> > current->sysc_cnt
> > +#endif /* CONFIG_THREAD_PERF_STAT_SYSC */
> 
> Please dont call a function to do one increment !
> 
> You are touching one of the most critical part of the kernel...

Obviously Eric and I looked at this looking for totally different things. :)

Thanks for spotting that, I totally failed to notice that part....


--==_Exmh_1175723672_4061P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGFB6YcC3lWbTT17ARAkOaAKCKiwX05UjqcbNPrK2GWJE4BcY4cACfVzNQ
/bz8mdnU0qDkHfZpPt0Y+hw=
=uuCB
-----END PGP SIGNATURE-----

--==_Exmh_1175723672_4061P--
