Return-Path: <linux-kernel-owner+w=401wt.eu-S964828AbXCGE4J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828AbXCGE4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:56:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964865AbXCGE4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:56:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53898 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828AbXCGE4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:56:08 -0500
Date: Wed, 7 Mar 2007 15:55:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
Message-Id: <20070307155553.06c82ca1.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Mar_2007_15_55_53_+1100_RZWWLeofYNpXFLFA"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Mar_2007_15_55_53_+1100_RZWWLeofYNpXFLFA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 6 Mar 2007 17:36:56 -0800 (PST) Davide Libenzi <davidel@xmailserver.org> wrote:
>
> The read(2) call will read u32 signal numbers that landed over the
> signalfd. It returns the size of the data copied, or zero if the sighand
> we are attached to, has been detached.

So what about signals that the user asked for a siginfo_t to be returned
with?

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Mar_2007_15_55_53_+1100_RZWWLeofYNpXFLFA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF7kXiFdBgD/zoJvwRAhpqAKCPiYYupZgWsvQYYS/bJi8m5M79GQCfXdbO
CqG59AsJk1JN7hUbe0GvG54=
=h/wM
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Mar_2007_15_55_53_+1100_RZWWLeofYNpXFLFA--
