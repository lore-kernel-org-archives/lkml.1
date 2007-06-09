Return-Path: <linux-kernel-owner+w=401wt.eu-S939562AbXFIBUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939562AbXFIBUv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 21:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbXFIBUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 21:20:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196AbXFIBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 21:20:42 -0400
Message-ID: <466A0020.50406@redhat.com>
Date: Fri, 08 Jun 2007 18:19:28 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
References: <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu> <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com> <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com> <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com> <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org> <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org> <20070609003622.GB4095@ftp.linux.org.uk>
In-Reply-To: <20070609003622.GB4095@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Al Viro wrote:
> Exactly.  Put it another way, randomizer is a stress-tester.

... and a security mechanism.  And as such it is only useful if it is
used.  Probably it should be policy-controlled whether you can turn it off.


> Note that
> #define NR_FILES <some constant>
> 
> for (i = 0; i < NR_FILES; i++)
> 	close(i);

You're confusing the problems.  This is not the argument for having a
separate file descriptor set.  It is the argument to have hidden file
descriptors.  Randomization has nothing whatsoever to do with this example.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGagAg2ijCOnn/RHQRAhV+AJ9qT2epTxDWWS++74f+vrV3NucVHACdGkxm
MULoyE+0NY7dSHcB2epKe7w=
=o3+1
-----END PGP SIGNATURE-----
