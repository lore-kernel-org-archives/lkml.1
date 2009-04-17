Return-Path: <linux-kernel-owner+w=401wt.eu-S1756272AbZDQU3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272AbZDQU3v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 16:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZDQU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 16:29:42 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40320 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbZDQU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 16:29:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H0UvTpzyA/Us75tKcbHEARYXAC65Bpp7nkZ2hg/ucqTP2EG5hacbj3XON5Cj1gonLC
         8NOFZ9Qb6fAk4o2zSLt7zqSz1jLoUAET4cfpPnFP/DdICeuf+X6VrNfVKhF7Ge4h0zB8
         k2f9cldWGAQb1sSEJTSJWSyGzb/VE3uPrOw9o=
Date: Fri, 17 Apr 2009 22:29:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090417202936.GB6331@nowhere>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090414153035.C662.A69D9226@jp.fujitsu.com> <20090414065303.GA24626@elte.hu> <49E8BB98.3090901@goop.org> <1239989260.23397.4848.camel@laptop> <alpine.DEB.2.00.0904171336030.14919@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0904171336030.14919@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 01:36:58PM -0400, Steven Rostedt wrote:
> 
> 
> On Fri, 17 Apr 2009, Peter Zijlstra wrote:
> 
> > On Fri, 2009-04-17 at 10:25 -0700, Jeremy Fitzhardinge wrote:
> > > Ingo Molnar wrote:
> > > > We could zap all pending trace entries on module unload (it is a 
> > > > rare operation)
> > > 
> > > ....Unless you're trying to trace something across a module unload.  I 
> > > don't know if its at all practical, but it would be nice to just zap the 
> > > pointers within the buffer, rather than the whole buffer.
> > 
> > I think the new __string() thing that's in the works will avoid the
> > whole problem by copying the string into the buffer, instead of keeping
> > a reference.
> 
> Speaking of which. We have not heard back from Frederic on this yet. I 
> hope he's taking a break, enjoying the sun, and not stuck on some tricky 
> macro crap ;-)
> 
> -- Steve
>



Oh you haven't yet received my mail about that?
It said I was cheering up about your and Peter's idea of using offsets
instead of pointer because of the end result:

- We can use as much __string() as we want
- No need for something else, such as the strcpy bits
- We are not forced to put it in the end of the patch
- Which means I will implement that in a v3 very soon ;-)

Frederic.

