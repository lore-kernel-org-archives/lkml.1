Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791AbZI1Iuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbZI1Iuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 04:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbZI1Iuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 04:50:52 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:42476 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZI1Iuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 04:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nru85uCE/GyTkbMFa3mYoQNX/FF+TufyZOn92L3JkfcUzNcct/UY2Evzkc3QcnJFim
         vQmXXHQYFcFn11gIXQ0yGflpgxOEXsIILX1Ka1wuJA2uoINLZZrccWKURLEbIz8LTJIM
         eNsXn8LVyjcNo8tT948+ncHKcidrrTvtab95U=
Date: Mon, 28 Sep 2009 10:50:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       tzanussi@gmail.com, lizf@cn.fujitsu.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing/filters: Provide basic regex support
Message-ID: <20090928085049.GB6142@nowhere>
References: <tip-1889d20922d14a97b2099fa4d47587217c0ba48b@git.kernel.org> <1253959805.12145.95.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253959805.12145.95.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 06:10:05AM -0400, Steven Rostedt wrote:
> On Fri, 2009-09-25 at 06:19 +0000, tip-bot for Frederic Weisbecker
> wrote:
> > Commit-ID:  1889d20922d14a97b2099fa4d47587217c0ba48b
> > Gitweb:     http://git.kernel.org/tip/1889d20922d14a97b2099fa4d47587217c0ba48b
> > Author:     Frederic Weisbecker <fweisbec@gmail.com>
> > AuthorDate: Thu, 24 Sep 2009 21:10:44 +0200
> > Committer:  Frederic Weisbecker <fweisbec@gmail.com>
> > CommitDate: Thu, 24 Sep 2009 21:39:27 +0200
> > 
> > tracing/filters: Provide basic regex support
> > 
> > This patch provides basic support for regular expressions in filters.
> > 
> > It supports the following types of regexp:
> > 
> > - *match_beginning
> > - *match_middle*
> > - match_end*
> > - !don't match
> > 
> > Example:
> > 	cd /debug/tracing/events/bkl/lock_kernel
> > 	echo 'file == "*reiserfs*"' > filter
> > 	echo 1 > enable
> 
> Darn! I need to keep up with my email more. Someone asked me at my
> ftrace tutorial if the filters can take regex's.  I told them that I
> don't think so. Of course, my tutorial was on 2.6.31 so I was still
> correct. But it would have been nice if I told them that it will in
> 2.6.32 or 33.
> 
> -- Steve


Hehe :-)

That said I guess it should be more for .33 than .32 I guess.

