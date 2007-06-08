Return-Path: <linux-kernel-owner+w=401wt.eu-S1751684AbXFHS6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbXFHS6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750912AbXFHS6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:58:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbXFHS6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:58:08 -0400
Message-ID: <4669A674.4080309@redhat.com>
Date: Fri, 08 Jun 2007 11:56:52 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com> <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com> <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com> <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu> <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk>
In-Reply-To: <20070608184650.GA4095@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> You are making debugging no end of fun...

We are talking about file descriptors here.  If you're using file
descriptors as anything other than tokens you'll find out soon enough
that your code is broken.  The new type of file descriptors cannot be
used as indeces and the randomization makes sure that no program by some
fluke happens to work.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGaaZ02ijCOnn/RHQRAkN0AJ9ZDdaoBDKbKMyDfZI7pa3E7w3pXwCeLlbB
9kRy/E09QvPhMOfjeVYPNio=
=Cjh7
-----END PGP SIGNATURE-----
