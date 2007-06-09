Return-Path: <linux-kernel-owner+w=401wt.eu-S970356AbXFIAHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970356AbXFIAHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030458AbXFIAFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:05:17 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969754AbXFIAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:05:13 -0400
Date: Fri, 8 Jun 2007 17:03:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ulrich Drepper <drepper@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org>
References: <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
 <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com>
 <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Jun 2007, Davide Libenzi wrote:
>
> On Fri, 8 Jun 2007, Linus Torvalds wrote:
> > 
> > You need things to be *repeatable* for debugging. No ifs, buts, or maybes 
> > about it.
> 
> It all depends on how you use the file descriptor.

Read what I wrote. "for debugging".

If your code is bug-free, and does what you intend it to do, everything is 
fine. But you wouldn't be doing debugging then, would you?

For debugging, it does _not_ depend on "how you use the file descriptor". 
The whole _point_ is that something does something wrong. Maybe you 
_intended_ to use the file descriptor some way, and the bug was that you 
didn't.

		Linus
