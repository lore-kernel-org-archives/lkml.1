Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab0CHXLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:11:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab0CHXLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:11:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Lennart Poettering <mzxreary@0pointer.de>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
       Americo Wang <xiyou.wangcong@gmail.com>,
       James Morris <jmorris@namei.org>, Kay Sievers <kay.sievers@vrfy.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle McMartin <kyle@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: [PATCH] exit: PR_SET_ANCHOR for marking processes as reapers
 	for child processes
In-Reply-To: Lennart Poettering's message of  Saturday, 6 March 2010 01:20:09 +0100 <20100306002009.GI28657@tango.0pointer.de>
References: <20100202120457.GA19605@omega>
	<20100304140822.GA458@redhat.com>
	<20100304221434.17567187@magilla.sf.frob.com>
	<20100306002009.GI28657@tango.0pointer.de>
Emacs: because Hell was full.
Message-Id: <20100308231104.A513B1191@magilla.sf.frob.com>
Date: Mon,  8 Mar 2010 15:11:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Uh, no. Actually it's the fact that my sub-init gets the SIGCHLD, which
> I am looking for. The clean ps tree is just a side-effect.

Ok.  In that case, there is a substantial can of worms in considering
compatibility breakages, and especially the various wrinkles of setuid that
could be security issues.  It will take a lot of careful thought to be sure
how we can do this without opening new ways to confuse and abuse a setuid
program.


Thanks,
Roland
