Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346AbZCUWax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346AbZCUWax (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 18:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZCUWap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 18:30:45 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52218 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbZCUWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 18:30:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gIyLb2Y2L2vOjCurX6/IF2+ANLhb/Nvf2epH8DaxEHRanDfdZdFhKxW8otE5Azh19h
         Cz9ilvnuHbgNYreNV84P5lAX7oWxQRkwWaGeIaVHIj/jI9e/1hc+9gw8eeYednRtis4S
         7Ns26+aN00nghcqZYnysvoyrnvALGSKgveD3o=
Date: Sun, 22 Mar 2009 01:37:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Frank Ch. Eigler" <fche@redhat.com>, Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321223759.GA22770@x200.localdomain>
References: <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain> <20090321222030.GA5157@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321222030.GA5157@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 06:20:30PM -0400, Frank Ch. Eigler wrote:
> On Sat, Mar 21, 2009 at 03:02:59PM -0700, Linus Torvalds wrote:
> > [...]
> > > The thing is, utrace crashes in Fedora have dominated kerneloops.org 
> > > for many months [...]
> > 
> > .. and dammit, I agree 100%. If utrace really shows up in _any_ way on 
> > kerneloops.org, then I think THE ENTIRE DISCUSSION in this thread is moot. 
> 
> There was a short span of time during last fall, when Roland was on
> vacation.  That bug (in 2.6.26.3) was fixed during the kernel summit.
> So this is a six-month obsolete grievance.

struct task_struct::utrace became embedded struct. This is good and
should remove quite a few of utrace bugs. Better late than never.

However, "rewrite-ptrace-via-utrace" patch was omitted, so almost noone
can easily see by how much situation improved.

I see this patch was dropped in Fedora.

Will ptrace(2) will be rewritten through utrace?
