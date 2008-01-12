Return-Path: <linux-kernel-owner+w=401wt.eu-S1760832AbYALE7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760832AbYALE7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 23:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbYALE7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 23:59:12 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36878 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757416AbYALE7M (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 23:59:12 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: righiandr@users.sourceforge.net
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC][PATCH] per-task I/O throttling
In-Reply-To: Your message of "Fri, 11 Jan 2008 17:32:49 +0100."
             <47879A32.8060508@users.sourceforge.net>
From: Valdis.Kletnieks@vt.edu
References: <47869FFE.1050000@users.sourceforge.net> <661de9470801110759h318347acw5f08c91b48ca742d@mail.gmail.com>
            <47879A32.8060508@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1200113861_2766P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 11 Jan 2008 23:57:41 -0500
Message-ID: <3777.1200113861@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1200113861_2766P
Content-Type: text/plain; charset=us-ascii

On Fri, 11 Jan 2008 17:32:49 +0100, Andrea Righi said:

> The interesting feature is that it allows to set a priority for each
> process container, but AFAIK it doesn't allow to "partition" the
> bandwidth between different containers (that would be a nice feature
> IMHO). For example it would be great to be able to define per-container
> limits, like assign 10MB/s for processes in container A, 30MB/s to
> container B, 20MB/s to container C, etc.

Has anybody considered allocating based on *seeks* rather than bytes moved,
or counting seeks as "virtual bytes" for the purposes of accounting (if the
disk can do 50mbytes/sec, and a seek takes 5millisecs, then count it as 100K
of data)?

--==_Exmh_1200113861_2766P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHiEjFcC3lWbTT17ARAmeuAKD6jYLikX635wJ2Z1oCMU4JiH58SQCfV5Cx
AH0bnDayZ9BOm4CPoSvlNM0=
=/+by
-----END PGP SIGNATURE-----

--==_Exmh_1200113861_2766P--
