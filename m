Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZJBQvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZJBQvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbZJBQvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:51:31 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:51638 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbZJBQvb (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:51:31 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, riel@redhat.com
Subject: Re: IO scheduler based IO controller V10
In-Reply-To: Your message of "Fri, 02 Oct 2009 11:40:20 EDT."
             <20091002154020.GC4494@redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <200910021255.27689.czoccolo@gmail.com> <20091002124921.GA4494@redhat.com> <4e5e476b0910020827s23e827b1n847c64e355999d4a@mail.gmail.com> <1254497520.10392.11.camel@marge.simson.net>
            <20091002154020.GC4494@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1254502217_3334P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 02 Oct 2009 12:50:17 -0400
Message-ID: <12774.1254502217@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1254502217_3334P
Content-Type: text/plain; charset=us-ascii

On Fri, 02 Oct 2009 11:40:20 EDT, Vivek Goyal said:

> In that case, Corrado's suggestion of refining it further and disabling idling
> for seeky process only on non-rotational media (SSD and hardware RAID), makes
> sense to me.

Umm... I got petabytes of hardware RAID across the hall that very definitely
*is* rotating.  Did you mean "SSD and disk systems with big honking caches
that cover up the rotation"?  Because "RAID" and "big honking caches" are
not *quite* the same thing, and I can just see that corner case coming out
to bite somebody on the ass...


--==_Exmh_1254502217_3334P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKxi9JcC3lWbTT17ARApP2AJ4i2rJ5d8WCfE9DU/OfTmNPSD1P/ACg1mVC
KmoukBpnPxlD7yD8IMZMXw0=
=qKY6
-----END PGP SIGNATURE-----

--==_Exmh_1254502217_3334P--
