Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864Ab0AZFtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab0AZFtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 00:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525Ab0AZFtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 00:49:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33796 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0AZFtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 00:49:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tavis Ormandy <taviso@google.com>,
       Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [2.6.33-rc5] starting emacs makes lockdep warning
Cc: kosaki.motohiro@jp.fujitsu.com, Americo Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100126142644.5AB0.A69D9226@jp.fujitsu.com>
References: <2375c9f91001252125w6f5bd3d3he183c61e9dcedd3e@mail.gmail.com> <20100126142644.5AB0.A69D9226@jp.fujitsu.com>
Message-Id: <20100126144641.5AB3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Jan 2010 14:49:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, Jan 26, 2010 at 11:20 AM, KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> > > Hi
> > >
> > > Current linus tree made following lockdep warning when starting emacs command.
> > > Is this known issue?
> > >
> > >
> > > =========================================================
> > > [ INFO: possible irq lock inversion dependency detected ]
> > > 2.6.33-rc5 #77
> > > ---------------------------------------------------------
> > > emacs/1609 just changed the state of lock:
> > >  (&(&tty->ctrl_lock)->rlock){+.....}, at: [<ffffffff8127c648>] tty_fasync+0xe8/0x190
> > > but this lock took another, HARDIRQ-unsafe lock in the past:
> > >  (&(&sighand->siglock)->rlock){-.....}
> > >
> > > and interrupts could create inverse lock ordering between them.
> > >
> > >
> > 
> > Hey,
> > 
> > does reverting commit 703625118 help?
> 
> Seems solved.
> 
> Thanks.

I'm sorry.
I forgot to cc related person at last mail.

Greg, can you please consider revert commit 703625118?




