Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbXJJGMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbXJJGMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 02:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbXJJGMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 02:12:22 -0400
Received: from alnrmhc13.comcast.net ([206.18.177.53]:52357 "EHLO
	alnrmhc13.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXJJGMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 02:12:22 -0400
Subject: Re: Linux 2.6.23
From: Nicholas Miell <nmiell@comcast.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 09 Oct 2007 23:12:20 -0700
Message-Id: <1191996740.8694.7.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-09 at 13:54 -0700, Linus Torvalds wrote:
> Finally.
> 
> Yeah, it got delayed, not because of any huge issues, but because of 
> various bugfixes trickling in and causing me to reset my "release clock" 
> all the time. But it's out there now, and hopefully better for the wait.
> 
> Not a whole lot of changes since -rc9, although there's a few updates to 
> mips, sparc64 and blackfin in there.  Ignoring those arch updates, there's 
> basically a number of mostly one-liners (mostly in drivers, but there's 
> some networking fixes and soem VFS/VM fixes there too).
> 
> Shortlog and diffstat appended (both relative to -rc9, of course - the 
> full log from 2.6.22 is on kernel.org as usual).
> 
> I want this to be what people look at for a few days, but expect the x86 
> merge to go ahead after that. So far, all indications are still that it's 
> going to be all smooth sailing, but hey, those indicators seem to always 
> say that, and only after the fact do people notice any problems ;)
> 
> 		Linus

Does CFS still generate the following sysbench graphs with 2.6.23, or
did that get fixed?

http://people.freebsd.org/~kris/scaling/linux-pgsql.png
http://people.freebsd.org/~kris/scaling/linux-mysql.png

(There's also some interesting FreeBSD vs. Linux graphs in
http://people.freebsd.org/~kris/scaling/Scalability%20Update.pdf , but
AFAIK those comparisons are more indicative of glibc malloc performance
than Linux performance.)

-- 
Nicholas Miell <nmiell@comcast.net>

