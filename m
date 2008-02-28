Return-Path: <linux-kernel-owner+w=401wt.eu-S1760234AbYB1PFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760234AbYB1PFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 10:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbYB1PF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 10:05:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:39811 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbYB1PF1 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 10:05:27 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: 7eggert@gmx.de
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Pierre Habouzit <madcoder@debian.org>,
       lkml <linux-kernel@vger.kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Marc Lehmann <schmorp@schmorp.de>,
       David Schwartz <davids@webmaster.com>
Subject: Re: epoll and shared fd's
In-Reply-To: Your message of "Tue, 26 Feb 2008 19:16:30 +0100."
             <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
From: Valdis.Kletnieks@vt.edu
References: <9MZLT-1YO-33@gated-at.bofh.it> <9N6Ng-5tn-21@gated-at.bofh.it> <9P5WE-33i-11@gated-at.bofh.it> <9Pk9l-1KA-1@gated-at.bofh.it> <9PNNZ-b0-5@gated-at.bofh.it> <a19Lb-1F0-13@gated-at.bofh.it> <a19Lb-1F0-11@gated-at.bofh.it>
            <E1JU4Lu-0000mn-H2@be1.7eggert.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1204206788_3291P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 28 Feb 2008 08:53:08 -0500
Message-ID: <19752.1204206788@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1204206788_3291P
Content-Type: text/plain; charset=us-ascii

On Tue, 26 Feb 2008 19:16:30 +0100, Bodo Eggert said:
> Michael Kerrisk <mtk.manpages@googlemail.com> wrote:

> >               file  handle  have  been  closed.  This means that
> >               even after a file descriptor that is  part  of  an
> >               epoll  set has been closed, events may be reported
> >               for that file descriptor if other file descriptors
> >               referring  to the same underlying file description
> >               remain open.

Is it worth making special mention of the case where a process gets events
for a FD that it has closed, because a parent or child process still has
an inherited copy of the FD still open?

--==_Exmh_1204206788_3291P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHxrzEcC3lWbTT17ARAkU2AKC03aYkoketvvttb5jSP/t7WmIN4QCg/edR
dV/EcKfw7Hw8h6n3iyHwGSA=
=atFQ
-----END PGP SIGNATURE-----

--==_Exmh_1204206788_3291P--
