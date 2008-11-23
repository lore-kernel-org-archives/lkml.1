Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbYKWMov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbYKWMov (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYKWMom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:44:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754582AbYKWMol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:44:41 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11965] regression introduced by - timers: fix itimer/many thread hang
Date: Sun, 23 Nov 2008 13:43:49 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Doug Chapman <doug.chapman@hp.com>, Frank Mayhar <fmayhar@google.com>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
References: <sBqd4qMeLzC.A.mgB.B7HKJB@chimera> <vyitTh0pP2N.A.t7C.D8HKJB@chimera> <20081123073929.GA23229@elte.hu>
In-Reply-To: <20081123073929.GA23229@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811231343.50307.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 23 of November 2008, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report 
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions 
> > from 2.6.27.  Please verify if it still should be listed and let me 
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11965
> > Subject		: regression introduced by - timers: fix itimer/many thread hang
> > Submitter	: Doug Chapman <doug.chapman@hp.com>
> > Date		: 2008-11-06 11:03 (17 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=f06febc96ba8e0af80bcc3eaec0a109e88275fac
> > References	: http://marc.info/?l=linux-kernel&m=122596943416648&w=4
> > Handled-By	: Frank Mayhar <fmayhar@google.com>
> > 		  Peter Zijlstra <peterz@infradead.org>
> > 		  Ingo Molnar <mingo@elte.hu>
> 
> the hang is fixed by:
> 
>   commit ad474caca3e2a0550b7ce0706527ad5ab389a4d4
>   Author: Oleg Nesterov <oleg@redhat.com>
>   Date:   Mon Nov 10 15:39:30 2008 +0100
> 
>     fix for account_group_exec_runtime(), make sure ->signal can't be freed under rq->lock

Thanks for the info and thanks for closing the bug. :-)

Rafael
