Return-Path: <linux-kernel-owner+w=401wt.eu-S1757258AbZD2GXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757258AbZD2GXb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 02:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752827AbZD2GXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 02:23:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbZD2GXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 02:23:21 -0400
Date: Tue, 28 Apr 2009 23:20:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-Id: <20090428232000.6c3d4ce1.akpm@linux-foundation.org>
In-Reply-To: <20090429060955.GD6148@elte.hu>
References: <20090429044814.138790038@goodmis.org>
	<20090429045908.394874083@goodmis.org>
	<20090428222024.8db50539.akpm@linux-foundation.org>
	<20090429054359.GA6148@elte.hu>
	<20090428225541.9ca61a12.akpm@linux-foundation.org>
	<20090429060955.GD6148@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 08:09:55 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 29 Apr 2009 07:43:59 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > On Wed, 29 Apr 2009 00:48:19 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > 
> > > > > -	printk_once(KERN_WARNING "Tracing recursion: depth[%d]:"
> > > > > +	printk_once(KERN_WARNING "Tracing recursion: depth[%ld]:"
> > > > 
> > > > hrmph.  I didn't know that printk_once() existed, and I should 
> > > > have known.  I wonder how many other people don't know.
> > > 
> > > Was posted to linux-next@vger.kernel.org.
> > 
> > Well no wonder I didn't know about it.
> 
> I (too?) think it's counter-productive that the linux-next list is 
> split out of lkml. I constantly fall into that trap: i get a 
> bugreport against one of our trees, i see that there's vger in the 
> Cc: list and mistake it for being Cc:-ed to lkml (all our trees are 
> developed on lkml and most of the bugreports come Cc:-ed to lkml) 
> but in reality it's Cc:-ed to linux-next which has a much smaller 
> audience. (which audience apparently does not even include you)
> 
> If this email list fragmentation and the resoluting loss of 
> information bothers you too then please ask Stephen to move 
> linux-next mails to lkml (i've Cc:-ed Stephen) - it's not like it's 
> actually something separate ... today's linux-next messages are 
> tomorrow's lkml messages. Moving linux-next mails to lkml would 
> nicely improve the S/N ratio on lkml.
> 

eh.  Just auto-add lkml to tipbot-commit emails?

printk_once() is racy on smp and preempt btw ;)
