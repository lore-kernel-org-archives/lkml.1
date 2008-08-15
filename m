Return-Path: <linux-kernel-owner+w=401wt.eu-S1758808AbYHONgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808AbYHONgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 09:36:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYHONgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 09:36:00 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:9510 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979AbYHONf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 09:35:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PX/I+2K4V7FC/5hjC+3fcWvYcgBoKtSNdSae4uJcAIfIUdhU7eRozkqCk3o3TX0rbD
         AqnlYzeLqeg4x5q22BHJovyKLu7DQEX4eHMB9OzYMotlwi28u1tjcNhpXm7MzCe/X/2Y
         4PSYu9yGkQJOtKNcmWqlGgaGPm+rBGwY5Pjqk=
Date: Fri, 15 Aug 2008 15:35:22 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 0/6] ftrace: to kill a daemon (small updates)
Message-ID: <20080815133517.GA5292@joi>
References: <20080814194506.233473381@goodmis.org> <20080815123624.GC5285@joi> <alpine.DEB.1.10.0808150840410.1065@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808150840410.1065@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 08:50:57AM -0400, Steven Rostedt wrote:
> 
> On Fri, 15 Aug 2008, Marcin Slusarz wrote:
> 
> > On Thu, Aug 14, 2008 at 03:45:06PM -0400, Steven Rostedt wrote:
> > >   Note 2: I have found that the changes here are more stable than
> > >     the current daemon method, and these patches should be used.
> > >     It also solves the resume from suspend to ram bug that was
> > >     reported:
> > > 
> > >       http://lkml.org/lkml/2008/8/12/234
> > >        and
> > >       http://lkml.org/lkml/2008/8/12/451
> > 
> > I don't remember testing any patch for my bug... ;)
> > 
> > For which tree this patchset is?
> > I tried to apply it on rc3, rc3+tip/tip and rc3+tip/master and all failed.
> > 
> 
> Ah, Bruce reported the same error, and said this patch series fixed it. 
> I assumed that this would fix your bug too. But if it does not, then I
> need to look deeper into what you are reporting.
> 
> Could you recheck-out the latest tip/master and see if it works for you.

Ok, I tried tip/master and resume from suspend to ram works again.
Thanks!

Marcin
