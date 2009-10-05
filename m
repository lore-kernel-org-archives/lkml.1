Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbZJEWS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbZJEWS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 18:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZJEWS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 18:18:58 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:33839 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbZJEWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 18:18:57 -0400
Date: Mon, 05 Oct 2009 18:17:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, balbir@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Shaohua Li <shaohua.li@intel.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for 2.6.32-rc1
In-reply-to: <200910052351.53207.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.0910051805500.32307@localhost.localdomain>
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
 <200910052159.24920.rjw@sisk.pl>
 <alpine.LFD.2.01.0910051354450.3432@localhost.localdomain>
 <200910052351.53207.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Rafael J. Wysocki wrote:

> On Monday 05 October 2009, Linus Torvalds wrote:
> > 
> > On Mon, 5 Oct 2009, Rafael J. Wysocki wrote:
> > > 
> > > This thing has already been merged, it appears: and it looks like a 
> > > total breakage of rules to me.
> > 
> > Well, Len pointed out to me that the NAK is kind of pointless, since it 
> > had no constructive alternatives to the issue. So he left it in as 
> > documentation, but until the scheduler people can actually _do_ something 
> > about the problem, their voice doesn't really matter, does it?
> 
> Well, for a patch that was objected to so strongly, I think it didn't get
> enough review from other relevant people before being pushed upstream.

Originally we proposed various "cute" scheduler tricks to solve this 
problem.  Peter objected strongly to all of them.

So the patch evolved into something quite simple that
doesn't touch the scheduler at all.  However, Peter's
objection to the concept never went away.

> It looks like Balbir didn't see it before for one example.

Surprising, since Balbir is presumably in the same group
as Vaidy at IBM, who is well informed on this topic
and this thread.

> It's been lots of time since the patch was originally posted to send it to
> the LKML for discussion and so on and to receive some comments that
> might help to improve it.

There was no more actionable feedback on the patch.
The latest version was checked in in July, and has
been waiting for the 2.6.32 merge window ever since.

I don't claim that any code in Linux is either
perfect or permanent, but I think this driver is
useful and thus deserved to be upstream where it
can be useful to the widest group of customers.

I'll be happy to have it re-written three times
if Linux evolved to supply more sophisticated
features to handle this situation.

> I have no idea why that wasn't done and I suspect
> there was some corporate pressure on Len to push it upstream as quickly as
> possible.

The driver has simply been waiting for the Linux merge window.

cheers,
-Len

