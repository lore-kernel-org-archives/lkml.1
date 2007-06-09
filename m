Return-Path: <linux-kernel-owner+w=401wt.eu-S971175AbXFIAN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971175AbXFIAN4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 20:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967854AbXFIANp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 20:13:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2020 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbXFIANp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 20:13:45 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 8 Jun 2007 17:13:43 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ulrich Drepper <drepper@redhat.com>, Al Viro <viro@ftp.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Eric Dumazet <dada1@cosmosbay.com>, Kyle Moffett <mrmacman_g4@mac.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706081710260.5795@alien.or.mcafeemobile.com>
References: <466864F8.2050903@cosmosbay.com> <46686810.6030805@redhat.com>
 <Pine.LNX.4.64.0706071438020.6445@alien.or.mcafeemobile.com>
 <466880A4.3090908@redhat.com> <Pine.LNX.4.64.0706071534280.6445@alien.or.mcafeemobile.com>
 <20070608120746.GD12687@thunk.org> <20070608140150.6f31672f@the-village.bc.nu>
 <Pine.LNX.4.64.0706081108130.5519@alien.or.mcafeemobile.com>
 <20070608192652.4a291901@the-village.bc.nu> <4669A351.4010403@redhat.com>
 <20070608184650.GA4095@ftp.linux.org.uk> <4669A674.4080309@redhat.com>
 <alpine.LFD.0.98.0706081206430.4205@woody.linux-foundation.org>
 <Pine.LNX.4.64.0706081211050.5795@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0706081701250.4205@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007, Linus Torvalds wrote:

> On Fri, 8 Jun 2007, Davide Libenzi wrote:
> >
> > On Fri, 8 Jun 2007, Linus Torvalds wrote:
> > > 
> > > You need things to be *repeatable* for debugging. No ifs, buts, or maybes 
> > > about it.
> > 
> > It all depends on how you use the file descriptor.
> 
> Read what I wrote. "for debugging".
> 
> If your code is bug-free, and does what you intend it to do, everything is 
> fine. But you wouldn't be doing debugging then, would you?
> 
> For debugging, it does _not_ depend on "how you use the file descriptor". 
> The whole _point_ is that something does something wrong. Maybe you 
> _intended_ to use the file descriptor some way, and the bug was that you 
> didn't.

Ok, so what's your idea? Have another POSIX-like allocator somewhere up 
there in the fd space, with a fixed and include-defined base?
Or just drop all this altogether?



- Davide


