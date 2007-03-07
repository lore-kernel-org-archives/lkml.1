Return-Path: <linux-kernel-owner+w=401wt.eu-S965617AbXCGR3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965617AbXCGR3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXCGR2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:28:50 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44818 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965597AbXCGR2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:28:46 -0500
Date: Wed, 7 Mar 2007 09:26:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kirk Kuchov <kirk.kuchov@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, Davide Libenzi <davidel@xmailserver.org>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, Theodore Tso <tytso@mit.edu>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0703070925200.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com> 
 <20070303100625.GA22557@2ka.mipt.ru>  <Pine.LNX.4.64.0703030945030.7075@alien.or.mcafeemobile.com>
  <20070303203140.GA756@2ka.mipt.ru>  <Pine.LNX.4.64.0703031248450.7278@alien.or.mcafeemobile.com>
  <ca9528de0703040823x340b0b7fw923b9bae8bcf0e7@mail.gmail.com> 
 <Pine.LNX.4.64.0703041129550.3300@alien.or.mcafeemobile.com> 
 <ca9528de0703041449x695a4c4bpc133d9afd5524019@mail.gmail.com> 
 <20070306081935.GB2040@elf.ucw.cz> <ca9528de0703070402r3d189348t78d27cf3b80b4623@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Kirk Kuchov wrote:
> 
> I don't believe I'm wasting my time explaining this. They don't exist
> as /dev/null, they are just fucking _LINKS_. I could even "ln -s
> /proc/self/fd/0 sucker". A real /dev/stdout can/could even exist, but
> that's not the point!

Actually, one large reason for /proc/self/ existing is exactly /dev/stdin 
and friends.

And yes, /proc/self looks like a link too, but that doesn't change the 
fact that it's a very special file. No different from /dev/null or 
friends.

		Linus
