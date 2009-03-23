Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbZCWQIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbZCWQIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:08:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758169AbZCWQIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:08:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51254 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758735AbZCWQIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:08:20 -0400
Date: Mon, 23 Mar 2009 17:08:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] debugfs: function to know if debugfs is initialized
Message-ID: <20090323160811.GB27151@elte.hu>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com> <1237759847-21025-2-git-send-email-fweisbec@gmail.com> <20090323081805.GA18837@elte.hu> <20090323144108.GA2409@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323144108.GA2409@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <gregkh@suse.de> wrote:

> On Mon, Mar 23, 2009 at 09:18:05AM +0100, Ingo Molnar wrote:
> > 
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 
> > > With ftrace, some tracers are registered in early initcalls
> > > and attempt to create files on the debugfs filesystem.
> > > Depending on when they are activated, they can try to create their
> > > file at any time. Some checks can be done on the tracing area
> > > but providing a helper to know if debugfs is registered make it
> > > really more easy.
> > > 
> > > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > ---
> > >  fs/debugfs/inode.c      |   16 ++++++++++++++++
> > >  include/linux/debugfs.h |    8 ++++++++
> > >  2 files changed, 24 insertions(+), 0 deletions(-)
> > 
> > Greg, is this patch is fine with you?
> 
> This patch is fine with me, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> to it.
> 
> > If yes, then would you mind if we picked this up into the tracing 
> > tree - as a subsequent fix-patch relies on it. There's no debugfs 
> > patches pending that i can see that would conflict with this.
> 
> Yes, that is fine, please take it through the tracing tree.

Thanks Greg!

	Ingo
