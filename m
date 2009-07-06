Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZGFWqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZGFWqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 18:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752769AbZGFWp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 18:45:59 -0400
Received: from www.tglx.de ([62.245.132.106]:54327 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752549AbZGFWp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 18:45:59 -0400
Date: Tue, 7 Jul 2009 00:44:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Christoph Lameter <cl@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip V2] x86: thread_info.h moving comment to where it
 should be
In-Reply-To: <1246914309.2478.2.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0907062321370.19480@localhost.localdomain>
References: <1246879925.28541.3.camel@hpdv5.satnam>  <alpine.LFD.2.00.0907062052230.19480@localhost.localdomain> <1246914309.2478.2.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder,

On Tue, 7 Jul 2009, Jaswinder Singh Rajput wrote:
> On Mon, 2009-07-06 at 20:54 +0200, Thomas Gleixner wrote:
> > On Mon, 6 Jul 2009, Jaswinder Singh Rajput wrote:
> > > 
> > > By mistake commit 2052e8d40ad58 moved following comment to wrong place,
> > > where it does not make any sense :
> > 
> > Wrong. commit 2052e8d4 had the comments in the right place. commit
> > 3351cc03 replaced the two identical INIT_THREAD_INFO macros and did
> > not update the comments.
> > 
> 
> Ahh so you was also part of it, here is updated patch:

if you expect that you earn more trust by such snotty comments, then
you are really on the wrong track. To keep the record straight:

 _You_ sent a patch with a bogus patch description.

Instead of silently sending a fixed up patch after I pointed out to
you that your commit log is incorrect you come back and make pompous
comments about who is doing wrong and who has taken part of it.

> [PATCH -tip] x86: thread_info.h moving comment to where it should be
> 
> By mistake commit 3351cc03 forget to move following comment along
> with INIT_THREAD_INFO :
> 
>  "preempt_count needs to be 1 initially, until the scheduler is functional."
> 
> Moving comment back to right place where preempt_count is setting to 1
> 
> Also by mistake commit 2052e8d4 forget to fix extra line which is not required.
> Removed that extra line.

That changelog is just another proof of your attempts to make a
moutain out of a molehill:

It does not matter at all which commit did not move a comment and it
does even matter less which commit did not remove or added a blank
line. For this patch a commit message consisting of a single subject
line:

  x86: thread_info.h: move comment and remove stray newline

is sufficient and more useful than your "by mistake ..."
fingerpointing.

We care about those details with _real_ code bugs, but not for the
sake of pointing at the person who made a mistake. We simply care
because we want a reference to the context where and why it happened.

Thanks,

	tglx
