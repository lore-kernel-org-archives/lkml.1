Return-Path: <linux-kernel-owner+w=401wt.eu-S933620AbXDIOwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933620AbXDIOwL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:52:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933605AbXDIOwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:52:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46037 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933613AbXDIOwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:52:09 -0400
Date: Mon, 9 Apr 2007 09:52:04 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Robin Holt <holt@sgi.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070409145204.GB20130@lnx-holt.americas.sgi.com>
References: <20070408155337.GA126@tv-sign.ru> <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com> <20070408165750.GA149@tv-sign.ru> <m1d52e2w86.fsf@ebiederm.dsl.xmission.com> <20070409090643.GA121@tv-sign.ru> <20070409104302.GA14764@lnx-holt.americas.sgi.com> <m18xd13996.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m18xd13996.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 08:36:21AM -0600, Eric W. Biederman wrote:
> Robin Holt <holt@sgi.com> writes:
> 
> > I would say this is more a benefit than a problem.  With a couple of these
> > systems we are testing, the number of kernel threads is far greater than
> > the number of user processes and having pstree not normally show them, but
> > maybe have an option we add later to show them again would be beneficial.
> 
> Sure.
> 
> Robin how many kernel thread per cpu are you seeing?

10.

FYI, pid 1539 is kthread.

a01:~ # ps -ef | egrep "\[.*\/255\]" 
root       512     1  0 Apr08 ?        00:00:00 [migration/255]
root       513     1  0 Apr08 ?        00:00:00 [ksoftirqd/255]
root      1281     1  0 Apr08 ?        00:00:02 [events/255]
root      2435  1539  0 Apr08 ?        00:00:00 [kblockd/255]
root      3159  1539  0 Apr08 ?        00:00:00 [aio/255]
root      4007  1539  0 Apr08 ?        00:00:00 [cqueue/255]
root      8653  1539  0 Apr08 ?        00:00:00 [ata/255]
root     17438  1539  0 Apr08 ?        00:00:00 [xfslogd/255]
root     17950  1539  0 Apr08 ?        00:00:00 [xfsdatad/255]
root     18426  1539  0 Apr08 ?        00:00:00 [rpciod/255]


Thanks,
Robin
