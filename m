Return-Path: <linux-kernel-owner+w=401wt.eu-S1751197AbXDIKnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbXDIKnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 06:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbXDIKnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 06:43:12 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50380 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751078AbXDIKnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 06:43:10 -0400
Date: Mon, 9 Apr 2007 05:43:02 -0500
From: Robin Holt <holt@sgi.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
Message-ID: <20070409104302.GA14764@lnx-holt.americas.sgi.com>
References: <20070408155337.GA126@tv-sign.ru> <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com> <20070408165750.GA149@tv-sign.ru> <m1d52e2w86.fsf@ebiederm.dsl.xmission.com> <20070409090643.GA121@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070409090643.GA121@tv-sign.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 01:06:43PM +0400, Oleg Nesterov wrote:
> On 04/08, Eric W. Biederman wrote:
> > There is a practical question how much we care about pstree being
> > confused (I assume it doesn't crash).  If this is just a confusion
> > issue then I say go for it.  PPID == 0 is a very legitimate way to say
> > the kernel is the parent process.
> 
> No, it doesn't crash. It just doesn't show kernel threads (ps ax is OK).
> I didn't look into the sources, but I guess the reason is that pstree
> assumes that the "root" of the tree is "pid == 1" process.

I would say this is more a benefit than a problem.  With a couple of these
systems we are testing, the number of kernel threads is far greater than
the number of user processes and having pstree not normally show them, but
maybe have an option we add later to show them again would be beneficial.

Thanks,
Robin
