Return-Path: <linux-kernel-owner+w=401wt.eu-S1751891AbZH0EfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbZH0EfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 00:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbZH0Ee6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 00:34:58 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:43082 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZH0Ee6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 00:34:58 -0400
X-Greylist: delayed 2220 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 00:34:55 EDT
Subject: Re: [GIT PULL, v4] S+core architecture (arch/score) support
From: Chen Liqin <liqin.chen@sunplusct.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <200908261931.52645.arnd@arndb.de>
References: <1251266324.16454.10.camel@ad3ser01>
	 <200908261931.52645.arnd@arndb.de>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 11:28:59 +0800
Message-Id: <1251343739.23810.24.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 19:31 +0200, Arnd Bergmann wrote:
> On Wednesday 26 August 2009, Chen Liqin (Gmail) wrote:
> 
> Hi Liqin,
> 
> Similarly, the split of your patches is good for review, but it
> is useless to have 33 commits in your changelog with just the
> file names listed in the history text.

I will remove these changelog from repository.

> 
> What is missing OTOH is a description of changes you made since
> the last version you posted, which would be needed to help
> people that have already reviewed your code before.
> Also, you have dropped the descriptions of changes that I
> contributed, committing the changed files as your own. If you
> see a need to do that next time, please ask before you do it,
> or find a way to keep the original commit logs.

How can I add old commit logs to our repository?
Or add people's contribute to the log?

> What is the status of the port now? Do you have a working glibc
> and LTP test results, or are do you still need to fix more
> bugs that got introduced in the 2.6.30 port?

In fact, we still need define 
__ARCH_WANT_SYSCALL_NO_AT,
__ARCH_WANT_SYSCALL_NO_FLAGS,
__ARCH_WANT_SYSCALL_OFF_T,
__ARCH_WANT_SYSCALL_DEPRECATED
to make linux/score running, glibc and applictions 
need old syscall API.
And now it's really have some problems
in syscall interface part.

But if we use our old syscall interface replace the new one,
score platform will run well.
I am a little confused, whether or not I should commit
score code use new or old syscall part?

Best Regards
Liqin

