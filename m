Return-Path: <linux-kernel-owner+w=401wt.eu-S934626AbZHEPIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934626AbZHEPIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 11:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934577AbZHEPIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 11:08:50 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:44801 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605AbZHEPIt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 11:08:49 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, fweisbec@gmail.com, rostedt@goodmis.org,
       mel@csn.ul.ie, lwoodman@redhat.com, riel@redhat.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/4] tracing, page-allocator: Add a postprocessing script for page-allocator-related ftrace events
In-Reply-To: Your message of "Tue, 04 Aug 2009 13:18:18 PDT."
             <20090804131818.ee5d4696.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-5-git-send-email-mel@csn.ul.ie> <20090804112246.4e6d0ab1.akpm@linux-foundation.org> <20090804195717.GA5998@elte.hu>
            <20090804131818.ee5d4696.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1249484839_3824P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 05 Aug 2009 11:07:19 -0400
Message-ID: <16859.1249484839@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1249484839_3824P
Content-Type: text/plain; charset=us-ascii

On Tue, 04 Aug 2009 13:18:18 PDT, Andrew Morton said:

> As usual, we're adding tracepoints because we feel we must add
> tracepoints, not because anyone has a need for the data which they
> gather.

One of the strong points of the Solaris 'dtrace' is that the kernel comes
pre-instrumented with zillions of tracepoints, including a lot that don't
seem to have very much application - just so they're already in place in
case you hit some weird issue and need the tracepoint for an ad-crock dtrace
script to debug something.  So when I'm trying to diagnose why my backup
server suddenly got sluggish 3 terabytes into a 5 terabyte backup, and it
looks like some weird fiberchannel issue, I can collect data without having
to reboot to install a tracepoint (which would lose the backup, and possibly
reset the issue or otherwise make it go into hiding).

Just sayin'. :)

--==_Exmh_1249484839_3824P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKeaAncC3lWbTT17ARAtwEAJ0am+oset6/fbEDDzGOBtdp4Pg4UwCfXs60
s8pZGjPrLA/XchwVAvEW4Ic=
=CRJO
-----END PGP SIGNATURE-----

--==_Exmh_1249484839_3824P--
