Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbZCWPLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbZCWPLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 11:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbZCWPLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 11:11:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51480 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbZCWPLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 11:11:00 -0400
Date: Mon, 23 Mar 2009 07:41:08 -0700
From: Greg KH <gregkh@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] debugfs: function to know if debugfs is initialized
Message-ID: <20090323144108.GA2409@suse.de>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com> <1237759847-21025-2-git-send-email-fweisbec@gmail.com> <20090323081805.GA18837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323081805.GA18837@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 09:18:05AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > With ftrace, some tracers are registered in early initcalls
> > and attempt to create files on the debugfs filesystem.
> > Depending on when they are activated, they can try to create their
> > file at any time. Some checks can be done on the tracing area
> > but providing a helper to know if debugfs is registered make it
> > really more easy.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  fs/debugfs/inode.c      |   16 ++++++++++++++++
> >  include/linux/debugfs.h |    8 ++++++++
> >  2 files changed, 24 insertions(+), 0 deletions(-)
> 
> Greg, is this patch is fine with you?

This patch is fine with me, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to it.

> If yes, then would you mind if we picked this up into the tracing 
> tree - as a subsequent fix-patch relies on it. There's no debugfs 
> patches pending that i can see that would conflict with this.

Yes, that is fine, please take it through the tracing tree.

greg k-h
