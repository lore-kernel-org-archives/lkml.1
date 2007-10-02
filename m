Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbXJBTiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbXJBTiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 15:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbXJBTh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 15:37:59 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:53326 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbXJBTh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 15:37:58 -0400
Date: Tue, 2 Oct 2007 15:37:28 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Kravetz <kravetz@us.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>
Subject: Re: -rt scheduling: wakeup bug?
In-Reply-To: <20071002193050.GB3162@monkey.ibm.com>
Message-ID: <Pine.LNX.4.58.0710021536001.12287@gandalf.stny.rr.com>
References: <20071001221519.GA20671@monkey.ibm.com> <20071002050632.GB28345@elte.hu>
 <20071002193050.GB3162@monkey.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Tue, 2 Oct 2007, Mike Kravetz wrote:

> On Tue, Oct 02, 2007 at 07:06:32AM +0200, Ingo Molnar wrote:
> > * Mike Kravetz <kravetz@us.ibm.com> wrote:
> > >
> > > My observations/debugging/conclusions are based on an earlier version
> > > of the code.  It appears the same code/issue still exists in the most
> > > version.  But, I have not not done any work with the latest version.
> >
> > I believe you are right - nice catch of this very nontrivial bug! The
> > patch below is against .23-rc - do you think this fix (of moving the rt
> > wakeup sequence to after the activate_task()) is adequate?
>
> Yes, I have been running with a similar patch on a (much) earlier
> version of the code.  It has helped quite a bit.  I would have
> put together a patch for a later version, but my test environment
> is limited to this earlier version.

FYI,

I've incorporated Ingo's patch into the lastest -rt release.

 http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.23-rc9-rt1.bz2

-- Steve

