Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZKBBY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZKBBY3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 20:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZKBBY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 20:24:28 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33388 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbZKBBY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 20:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Dow9iWFiefiFwGbd6ZyrGiRrduvUqfUFzw6ebLBbmWEQKfzJs4JvCsGJG0SZEn2N4M
         Bcne8S7d2ExQulM2Eg5rf2kYPJyAAELzvnEHNPx7Y8zrVi0ulhjLvH2kbm+653nQ3qKb
         F+cIhIl7yODDdBs44UvxjyBgLvH2aLUUPW0Yg=
Date: Mon, 2 Nov 2009 02:24:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf trace errors
Message-ID: <20091102012429.GG5263@nowhere>
References: <20091011025441.GA18152@lst.de> <20091016083242.GA11174@elte.hu> <20091025071708.GA16936@lst.de> <c62985530910251643k6b3e59c0l6069b08741469b47@mail.gmail.com> <1256851489.26028.3247.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256851489.26028.3247.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 05:24:49PM -0400, Steven Rostedt wrote:
> On Mon, 2009-10-26 at 00:43 +0100, Frederic Weisbecker wrote:
> > 2009/10/25 Christoph Hellwig <hch@lst.de>:
> > > On Fri, Oct 16, 2009 at 10:32:42AM +0200, Ingo Molnar wrote:
> > >> FYI, these bugs are fixed in latest -tip, your testcase works for me:
> > >
> > >> Mind checking whether it works for you?
> > >
> > > Yes, it works on -tip, but not yet on mainline.  What still doesn't
> > > work yet on -tip either is printing of dynamic strings in some events,
> > > e.g.:
> > >
> > >       kjournald-1105  [000]   643.002702: block_rq_complete: 253,0 W () 2283224
> > 
> > 
> > Ah, interesting, it means we support __string() but not well other
> > dynamic arrays.
> > I'll have a look at it.
> 
> Frederic,
> 
> Have you found anything with this yet? If not, I can take a look too.
> 


I haven't yet checked actually, I was out of my box this week.
But if you still have some time to check that too, then yeah,
it would be nice :)

Thanks.

