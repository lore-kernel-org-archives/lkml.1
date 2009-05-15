Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZEOXj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZEOXj6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 19:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZEOXju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 19:39:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:12234 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbZEOXjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 19:39:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=okoYeFi8NSJ5Ry3gAyS4YjkjYx19gOWU/pifaPz5/k2QxxYTD+CVQbD1zHqvCAOFfx
         9oZ4SDM14XJMsU3TLlBOtVhZqUhbf0NZA6Yf2JfaLY2etOQyu2/EwP/9iuCnAqBdeRew
         nDfW9cu5HZQ/iqzcR4gW6nBapuK9CNInlMnic=
Date: Sat, 16 May 2009 02:40:40 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/3] tracing: add flag output for kmem events
Message-ID: <20090515234040.GB3645@localhost>
References: <20090515210342.488025506@goodmis.org> <20090515210718.211132919@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515210718.211132919@goodmis.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 15, 2009 at 05:03:45PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> This patch changes the output for gfp_flags from being a simple hex value
> to the actual names.
> 
>   gfp_flags=GFP_ATOMIC  instead of gfp_flags=00000020
> 
> And even
> 
>   gfp_flags=GFP_KERNEL instead of gfp_flags=000000d0
> 
> [ Impact: more human readable output from tracer ]
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/trace/events/kmem.h |   43 +++++++++++++++++++++++++++++++++++--------
>  1 files changed, 35 insertions(+), 8 deletions(-)

As long as it doesn't touch (and I see it doesn't) the raw kmemtrace
output for kmemtrace-user, I'm okay with this sort of changes.

Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>

