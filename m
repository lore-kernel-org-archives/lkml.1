Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbYK0N64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbYK0N64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYK0N6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:58:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:64380 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbYK0N6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:58:46 -0500
Date: Thu, 27 Nov 2008 08:58:43 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/1] ring-buffer fix for 2.6.28
In-Reply-To: <492E0FD2.8040805@oracle.com>
Message-ID: <alpine.DEB.1.10.0811270856580.18691@gandalf.stny.rr.com>
References: <20081127025227.026028481@goodmis.org> <492E0FD2.8040805@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 26 Nov 2008, Randy Dunlap wrote:

> Steven Rostedt wrote:
> > The following patch needs to go into 2.6.28. It protects against
> > a recursion race that can happen when the scheduler is traced.
> > 
> > The following patches are in:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > 
> >     branch: devel
> > 
> > 
> > Lai Jiangshan (1):
> >       ring-buffer: prevent recursion
> > 
> > ----
> >  kernel/trace/ring_buffer.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Is there something about git that causes (or forces) the use of
> patch 0/1 followed by patch 1/1?  I find it terribly unwanted.
> 

It's my scripts that post. I should probably modify it so that if there is 
only one patch, that I append it to the prolog instead, and mail it out 
the old way. My scripts pull the patches out of my git tree and use quilt 
top post. I know git has a way to do that too, but I have not set that up.

-- Steve

