Return-Path: <linux-kernel-owner+w=401wt.eu-S933552AbXCJIYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933552AbXCJIYr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 03:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933545AbXCJIYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 03:24:45 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:45586 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933540AbXCJIYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 03:24:44 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sat, 10 Mar 2007 00:24:41 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Pavel Machek <pavel@ucw.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch v2] epoll use a single inode ...
In-Reply-To: <20070310080607.GA6511@ucw.cz>
Message-ID: <Pine.LNX.4.64.0703100019550.28135@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703051558070.3998@woody.linux-foundation.org>
 <Pine.LNX.4.64.0703051609430.4907@alien.or.mcafeemobile.com>
 <20070310080607.GA6511@ucw.cz>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Pavel Machek wrote:

> > Heh, this is what Al was saying ;)
> > I'm fine with that, but how about counter cycles (going back to zero)? 
> 
> Just use u64?

Yeah, the second patch was using an u64.
I ended up using a "class" name (signalfd, timerfd, asyncfd) as dname 
entry. An incremental counter would not add any useful information, and 
noone will ever care about dentry name of those objects. Prolly the class 
name is the only thing you might want to know, or we can drop even that 
and use a shared dentry for everything.


- Davide


