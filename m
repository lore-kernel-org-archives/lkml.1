Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZJ0QCn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZJ0QCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 12:02:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755836AbZJ0QCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 12:02:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755822AbZJ0QCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 12:02:41 -0400
Date: Tue, 27 Oct 2009 12:01:35 -0400
From: Jason Baron <jbaron@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091027160135.GA2623@redhat.com>
References: <20091025225342.007138f5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025225342.007138f5@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 25, 2009 at 10:53:42PM -0700, Arjan van de Ven wrote:
> diff --git a/include/trace/events/vfs.h b/include/trace/events/vfs.h
> new file mode 100644
> index 0000000..21cf9fb
> --- /dev/null
> +++ b/include/trace/events/vfs.h
> @@ -0,0 +1,53 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM vfs
> +
> +#if !defined(_TRACE_VFS_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_VFS_H
> +
> +/*
> + * Tracepoint for dirtying an inode:
> + */

hi,

I would like to see us add docbook style comments for each added trace
event. I've already started a docbook for this, and written comments for
the irq tracepoints, in include/trace/events/irq.h. The docbook can be
viewed at: http://www.kernel.org/doc/htmldocs/tracepoint/

I think there has been some talk that the documentation should be
included as part of the kernel, so that 'perf' can easily access this. I
don't see how these docbook style comments wouldn't help with that
effort as well. We already have scripts to parse these comments, and it
probably wouldn't be hard to extend them to create a binary version, if
needed. Further, as your above comment indicates, these types of
comments want to be included in the source code above the TRACE_EVENTS
macros.

The initial lkml postings were:

1) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02647.html
2) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02650.html
3) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02648.html
4) http://lkml.indiana.edu/hypermail/linux/kernel/0904.3/02651.html

thanks,

-Jason

