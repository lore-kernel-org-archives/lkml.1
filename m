Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbXJ3Xxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbXJ3Xxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 19:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753894AbXJ3Xxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 19:53:47 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:40084 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbXJ3Xxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 19:53:46 -0400
Date: Tue, 30 Oct 2007 19:53:24 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, kraj@mvista.com
Subject: Re: [PATCH -rt] remove in_interrupt() BUG_ON in exit path
In-Reply-To: <1193787796.4673.74.camel@imap.mvista.com>
Message-ID: <Pine.LNX.4.58.0710301951550.31349@gandalf.stny.rr.com>
References: <20071030224004.417523706@mvista.com> 
 <Pine.LNX.4.58.0710301939340.31349@gandalf.stny.rr.com>
 <1193787796.4673.74.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Tue, 30 Oct 2007, Daniel Walker wrote:

> On Tue, 2007-10-30 at 19:44 -0400, Steven Rostedt wrote:
>
> > I did this change once before, while debugging. I had the same issue. This
> > BUG_ON was giving me recursive crashes that prevented me knowing WTF was
> > going on.  I thought I even submitted a patch to remove it. Perhaps I
> > forgot to. Nope, I did!
> >
> > http://www.ussg.iu.edu/hypermail/linux/kernel/0707.0/1804.html
>
> I wonder if Ingo had his reasons for keeping it.. They're may have been
> a benefit to doing a BUG_ON at one point .. I don't know ..
>

I don't know. But since we now know at least two people got burned by this
BUG_ON being there (you and me). Maybe this was added before panic did a
dump_stack. Which I have no idea why the mainline doesn't dump_stack on
panic.

Hmm, I think I'll send a patch to see what people say ;-)

-- Steve

