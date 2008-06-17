Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYFQQMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYFQQMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbYFQQM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:12:29 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42650 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbYFQQM3 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:12:29 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Michael Kerrisk <mtk.manpages@googlemail.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>,
       Ivana Varekova <varekova@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org
Subject: Re: PR_SET_SECCOMP and PR_GET_SECCOMP doc (and bug?)
In-Reply-To: Your message of "Tue, 17 Jun 2008 15:32:29 +0200."
             <cfd18e0f0806170632p27a5ccd2obadaf0dfd4ce64aa@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <48565951.40603@gmail.com> <20080616162543.GA9552@duo.random>
            <cfd18e0f0806170632p27a5ccd2obadaf0dfd4ce64aa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1213719134_5877P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Jun 2008 12:12:14 -0400
Message-ID: <18697.1213719134@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1213719134_5877P
Content-Type: text/plain; charset=us-ascii

On Tue, 17 Jun 2008 15:32:29 +0200, Michael Kerrisk said:
> On Mon, Jun 16, 2008 at 6:25 PM, Andrea Arcangeli <andrea@qumranet.com> wrote:
> > On Mon, Jun 16, 2008 at 02:15:13PM +0200, Michael Kerrisk wrote:

> >>     PR_GET_SECCOMP (since Linux 2.6.23)
> >>         Return the secure computing mode  of  the  calling  thread.
> >>         Not  very  useful: if the caller is not in secure computing
> >>         mode, this operation returns 0; if the caller is in  secure
> >>         computing  mode, then the prctl() call will cause a SIGKILL
> >>         signal to be sent to the process.  This operation  is  only
> >>         available  if  the kernel is configured with CONFIG_SECCOMP
> >>         enabled.

Would it make sense to change the text to read "Not very useful for the
current implementation of mode=1" and/or add that it may be useful for
future modes that allow prctl() modes other than 1?

--==_Exmh_1213719134_5877P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIV+JecC3lWbTT17ARAhveAKDY1DP3M9vUeQq+aX7JeUYE+P853QCg/yZo
KJ0cgJiZqSJ5xwj02OwZuag=
=Ypgt
-----END PGP SIGNATURE-----

--==_Exmh_1213719134_5877P--
