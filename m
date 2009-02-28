Return-Path: <linux-kernel-owner+w=401wt.eu-S1755138AbZB1Tys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbZB1Tys (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 14:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbZB1Tyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 14:54:39 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:45705 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZB1Tyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 14:54:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dVY7kZjaAgYFOrPsPyzVFuGV9lC4GwHGlinRdJ+V9olxmCdhdkMnmW4hfBS8fZLmOB
         lCpGeASjj0t/z3qOltG0H0B+e6u8kDENoMjPXVxB+S5M+g1uziqrGnXUyI0LcROe79ep
         dRkUoI9qWPWbcW8jiqC4Mk+KxmYXW4zBEcwiA=
Date: Sat, 28 Feb 2009 20:54:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Luis Henriques <henrix@sapo.pt>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] tracing: remove unused code
Message-ID: <20090228195431.GA6574@nowhere>
References: <20090227202923.GA3826@hades.domain.com> <alpine.DEB.2.00.0902271535440.13395@gandalf.stny.rr.com> <20090228072137.GD9351@elte.hu> <20090228194004.GA9780@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228194004.GA9780@hades.domain.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 28, 2009 at 07:40:04PM +0000, Luis Henriques wrote:
> On Sat, Feb 28, 2009 at 08:21:37AM +0100, Ingo Molnar wrote:
> > 
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > Thanks Luis,
> > > 
> > > But before I remove this code, I want to move it to be 
> > > activated by tracing options. The irqsoff tracer (and other 
> > > latency tracers) are pretty useless without it.
> > 
> > sounds good.
> 
> Ok, understood.  I am sorry for the noise introduced by this patch... I should
> have got some more context before submitting it -- I am really not that familiar
> with this code and tried just to remove a compile warning without fully
> understand the whole picture :-)


Don't be sorry, the fix was right.
But nobody can be aware of all background history in a subsystem, unless one read
all tracing related posts but it is very active these time so it can be a little pain for
a newcomer.

 
> -- 
> Luis Henriques
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

