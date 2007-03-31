Return-Path: <linux-kernel-owner+w=401wt.eu-S933327AbXCaCZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327AbXCaCZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933325AbXCaCZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:25:06 -0400
Received: from smtp.osdl.org ([65.172.181.24]:33233 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322AbXCaCZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:25:04 -0400
Date: Fri, 30 Mar 2007 19:24:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [patch 1/13] signal/timer/event fds v8 - anonymous inode source
 ...
In-Reply-To: <20070330160850.d7988a87.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703301922280.6730@woody.linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.28743.1174415834.1>
 <20070330123943.8df1aa92.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703301532500.3721@alien.or.mcafeemobile.com>
 <20070330160850.d7988a87.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 Mar 2007, Andrew Morton wrote:
> > 
> > Ok, it was panincing, and someone made me change it. Would you please 
> > agree?
> > The system can survive w/out, but it'll be a broken system WRT userspace.
> 
> I'd say panic.  There's no much point in limping along with an
> incorrectly-working kernel, only to have some small number of apps fail
> mysteriously later on.

Well, in this case (since it's at bootup only), I'd agree with panic(), 
but generally I disagree - it's actually much better to have a broken 
system limping along and allowing things like syslogd to write the problem 
to log-files and generally working as well as possible.

If people can do a "dmesg" and send it out as an email, we're much more 
likely to get good bug-reports.

But for early boot, and for something that can't really happen anyway, 
panic() sounds fine.

		Linus
