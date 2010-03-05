Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab0CETTd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 14:19:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab0CETTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 14:19:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>,
       Lennart Poettering <lennart@poettering.net>,
       linux-kernel@vger.kernel.org, Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers for 
	child processes
In-Reply-To: Kay Sievers's message of  Friday, 5 March 2010 10:51:47 -0800 <ac3eb2511003051051r50468752o607a8a0309d5ce2e@mail.gmail.com>
References: <20100202120457.GA19605@omega>
	<20100304140822.GA458@redhat.com>
	<20100304221434.17567187@magilla.sf.frob.com>
	<ac3eb2511003051051r50468752o607a8a0309d5ce2e@mail.gmail.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20100305191816.5EC8ACC@magilla.sf.frob.com>
Date: Fri,  5 Mar 2010 11:18:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, no. Actually getting the SIGCHILD is the needed feature here. A
> process who sets the ANCHOR flag is surely expected to handle these
> signals. It's all about a user "init-like" process" that can do
> similar things for a logged-in user what /sbin/init can to for the
> system. So, it's all about 1.), and 3.) is a nice side-effect, but not
> the motivation to do this.

Please explain this more explicitly.  What the actual init does with
miscellaneous reparented processes is just reap them and ignore their
status.  What do you intend an "anchor" process to do other than that?


Thanks,
Roland
