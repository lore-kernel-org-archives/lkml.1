Return-Path: <linux-kernel-owner+w=401wt.eu-S1945966AbXBIBBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945966AbXBIBBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 20:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945972AbXBIBBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 20:01:08 -0500
Received: from smtp.osdl.org ([65.172.181.24]:47736 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945966AbXBIBBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 20:01:06 -0500
Date: Thu, 8 Feb 2007 17:00:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.21
Message-Id: <20070208170059.837d171e.akpm@linux-foundation.org>
In-Reply-To: <17867.50828.463593.134082@cargo.ozlabs.ibm.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>
	<20070208233449.GC18899@athena.road.mcmartin.ca>
	<20070208155300.9347e0cb.akpm@linux-foundation.org>
	<17867.50828.463593.134082@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 11:55:40 +1100
Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > Once a subsystem has a subsystem tree (git or quilt) I basically never
> > merge anything which belongs to that tree.  It's always
> > 
> > 	originator->mm->subsystemtree->Linus
> > 
> > If the subsystem tree maintainer wants to tell me "I can't be bothered
> > setting up a git pull for that, please merge it for me" then that's fine.
> > 
> > But unless I'm told that, or unless the maintainer is vacationing or totally
> > asleep or unless the fix has some sufficiently high obviousness*importance product,
> > I'll just keep buffering it up.  
> 
> What about the sort of thing that crosses all archs?  For example, the
> local_t changes?  Particularly in the case where the change has to be
> made in generic code and in all archs at the same time, it makes sense
> to me for you to send the whole batch to Linus at the same time,
> rather than individual arch maintainers all sending their bit at
> varying times.
> 

yup.  It's better of course if the changes aren't both-way dependent and
often we do it that way.  But if they really are that bound together then
I'll stage the patch in -mm, ensure that it doesn't conflict with any
queued-up arch patches and will merge it after the arch trees have gone in.

