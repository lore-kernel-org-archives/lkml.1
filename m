Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbZKKGk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbZKKGk0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 01:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbZKKGkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 01:40:25 -0500
Received: from mga03.intel.com ([143.182.124.21]:9444 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZKKGkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 01:40:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,721,1249282800"; 
   d="scan'208";a="210148192"
Date: Wed, 11 Nov 2009 14:40:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, "mingo@elte.hu" <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091111064027.GA11565@localhost>
References: <20091025225342.007138f5@infradead.org> <20091111020108.GA11423@localhost> <20091110223456.01ef355f@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110223456.01ef355f@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 02:34:56PM +0800, Arjan van de Ven wrote:
> On Wed, 11 Nov 2009 10:01:08 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > Hi Arjan,
> > 
> > > +	TP_printk("task=%i (%s) file=%s dev=%s",
> > > +		__entry->pid, __entry->comm, __entry->file,
> > > __entry->dev)
> > 
> > Maybe this is enough for POWERTOP, however for general use, the dirty
> > type(data/metadata) and inode number may be valuable to some users?
> 
> what can a user do with an inode number????

Hmm, maybe to tell one file from another in the trace stream :)
And maybe to compare it with other data sources, like "ls -i".

Thanks,
Fengguang
