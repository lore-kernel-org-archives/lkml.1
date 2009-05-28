Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbZE1OjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbZE1OjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 10:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZE1OjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 10:39:11 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:53930 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbZE1OjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 10:39:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cEAvpmU06ajFzs4WQR0vHZok/zqJn+MCh82UhXAf03cnpPAsvQYRudm8N7POes8sCM
         7T4oWb1YtRd9o89ler/kLAFq6cebhH6aw/2xWUTgTWCdKT9ZBJSpoo4mIb1yvO34xBjP
         hQ1AoyBeejlro1dYwF/y+kS8vt5TCcPU+amYc=
Date: Thu, 28 May 2009 16:39:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/lockdep: report the time waited for a lock
Message-ID: <20090528143907.GB6018@nowhere>
References: <1238975373-15739-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0905281032010.27708@gandalf.stny.rr.com> <1243521283.6645.0.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243521283.6645.0.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 04:34:43PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-05-28 at 10:32 -0400, Steven Rostedt wrote:
> 
> > > +	TP_STRUCT__entry(
> > > +		__field(const char *, name)
> > > +		__field(unsigned long, wait_usec)
> > > +		__field(unsigned long, wait_nsec_rem)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->name = lock->name;
> > > +		__entry->wait_nsec_rem = do_div(waittime, NSEC_PER_USEC);
> > 
> > I know this is already accepted, but can you move the do_div into the 
> > print section.
> 
> please do. Just fold those wait_* fields into a single u64 nsec one.


Indeed, I'll fix it. Thanks!

