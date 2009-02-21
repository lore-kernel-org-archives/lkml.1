Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZBUSbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZBUSbT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 13:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbZBUSbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 13:31:10 -0500
Received: from ns2.suse.de ([195.135.220.15]:60279 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZBUSbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 13:31:09 -0500
Date: Sat, 21 Feb 2009 10:29:02 -0800
From: Greg KH <gregkh@suse.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 0/9] PM: Fixes related to suspend and hibernation for
	2.6.29
Message-ID: <20090221182902.GB12472@suse.de>
References: <200902140157.40869.rjw@sisk.pl> <alpine.LFD.2.00.0902202337040.19156@localhost.localdomain> <200902211038.42169.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902211038.42169.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 10:38:40AM +0100, Rafael J. Wysocki wrote:
> On Saturday 21 February 2009, Len Brown wrote:
> > 
> > On Sat, 14 Feb 2009, Rafael J. Wysocki wrote:
> > 
> > > Hi Len,
> > > 
> > > The following are fixes related to suspend and hibernation I have collected
> > > over the last couple of weeks.  Some of them are in -mm.  I think they all are
> > > 2.6.29 material.
> > > 
> > > 1/9 and 2/9 fix hibernation regression caused by the async boot changes,
> > > I hope Greg will not object if they go through your tree.
> > > 
> > > 3/9 fixes a long-standing hibernation issue that cause the resume partition
> > > to become unuseable after two consecutive failing attempts to hibernate.
> > > 
> > > 4/9 fixes build of kprobes.c with CONFIG_PM unset.
> > 
> > looks like this one added power/ twice --
> 
> That was on purpose.
> 
> > and looks like akpm sent a fixed version of this to linus already?
> 
> Yes, he did.
> 
> > > 5/9 and 6/9 clean up memory freeing code used during hibernation.
> > > 
> > > 7/9 fixes a bug related to the use of PM notifiers during hibernation with
> > > the help of the user land interface.
> > > 
> > > 8/9 and 9/9 fix the handling of consoles during suspend/hibernation.
> > > 
> > > Please add these patches to the suspend branch and push to Linus for 2.6.29.
> > 
> > All except #4 are now on the suspend branch.
> 
> 1/9 and 2/9 are also in the Greg's tree, AFAICS.
> 
> Greg, do you intend to push them to Linus?  In that case I think it's better if
> Len drops them.

I was not planning to send them for .29, sorry I got confused.  I'll
drop them from my tree and Len can send them all to Linus now.

Is that ok?

thanks,

greg k-h
