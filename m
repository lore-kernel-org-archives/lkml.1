Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbXJ2TJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbXJ2TJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbXJ2TJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:09:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:56339 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbXJ2TJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:09:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:x-url:organization:user-agent:sender;
        b=uQKcTUdIk2axKSZfNZbLibmfqKWY37tr0M/wYIZHkS55a8LSyG0eRHU5/1nu7jlxSaERkrT/0Fwi6pjjYMxfSP3Js8KwRshEgqLD0l0lIY02lU5O18JAxl60i7BQvKfYAA117xFjAg/z4PZRqM4KvGYHKJD82EkRquW6qfWbk1U=
Date: Mon, 29 Oct 2007 17:08:46 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux/interrupt.h doesn't need sched.h
Message-ID: <20071029190845.GC7810@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20071029134539.GB7810@ghostprotocols.net> <20071029181210.GA1822@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029181210.GA1822@martell.zuzino.mipt.ru>
X-Url: http://oops.ghostprotocols.net:81/blog
Organization: OOPS Labs
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Oct 29, 2007 at 09:12:10PM +0300, Alexey Dobriyan escreveu:
> On Mon, Oct 29, 2007 at 11:45:39AM -0200, Arnaldo Carvalho de Melo wrote:
> > --- a/include/linux/interrupt.h
> > +++ b/include/linux/interrupt.h
> > @@ -9,7 +9,6 @@
> >  #include <linux/cpumask.h>
> >  #include <linux/irqreturn.h>
> >  #include <linux/hardirq.h>
> > -#include <linux/sched.h>
> >  #include <linux/irqflags.h>
> >  #include <asm/atomic.h>
> >  #include <asm/ptrace.h>
> 
> ACK the part that nothing needs sched.h, but it shouldn't change anything,
> because of interrupt.h => hardirq.h => smp_lock.h => sched.h dependency.

Yeah, but one thing at a time, now its one link in the maze, before it
was two :-)
 
> [puts patch on cross-compile farm anyway]
> [starts finding scalpels]

Thanks!

- Arnaldo
