Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZBQP0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZBQP0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 10:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZBQPZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 10:25:56 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:53592 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZBQPZz (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 10:25:55 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-02-14-00-49 uploaded -epoll busted.
In-Reply-To: Your message of "Sat, 14 Feb 2009 00:51:41 PST."
             <200902140851.n1E8pfIN030501@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200902140851.n1E8pfIN030501@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1234881458_6651P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 17 Feb 2009 09:37:38 -0500
Message-ID: <7379.1234881458@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1234881458_6651P
Content-Type: text/plain; charset=us-ascii

On Sat, 14 Feb 2009 00:51:41 PST, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-02-14-00-49 has been uploaded to

The epoll patch series breaks nscd in some odd way.  After it's started
in the /etc/rc* scripts, the rest of boot proceeds very slowly, smells like
nscd calls are hitting timeouts.  Boot time went from ~1 minute to ~10 mins.

nscd is Fedora Rawhide nscd-2.9.90-3.x86_64, in case that matters...

Also, the series isn't bisectable right where it matters most, complaining
about implicit definitions of wake_up_nested...

epoll-keyed-wakeups-v2-add-__wake_up_locked_key-and-__wake_up_sync_key.patch
epoll-keyed-wakeups-v2-introduce-new-_poll-wakeup-macros.patch  GOOD
epoll-keyed-wakeups-v3-introduce-new-_poll-wakeup-macros.patch  BISECT BUSTED
epoll-keyed-wakeups-v2-make-sockets-use-keyed-wakeups.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key.patch
epoll-keyed-wakeups-v2-teach-epoll-about-hints-coming-with-the-wakeup-key-update.patch  BAD



--==_Exmh_1234881458_6651P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJmsuycC3lWbTT17ARAgsdAKCb2V18rbMmesr60eusN6r+04fdzACcCvgd
LhdhGZxE0KkwyCRnK43YFW8=
=j923
-----END PGP SIGNATURE-----

--==_Exmh_1234881458_6651P--
