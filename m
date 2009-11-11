Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbZKKCBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbZKKCBH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756565AbZKKCBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:01:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:11083 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756537AbZKKCBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:01:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,719,1249282800"; 
   d="scan'208";a="210073705"
Date: Wed, 11 Nov 2009 10:01:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-ID: <20091111020108.GA11423@localhost>
References: <20091025225342.007138f5@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091025225342.007138f5@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,

> +	TP_printk("task=%i (%s) file=%s dev=%s",
> +		__entry->pid, __entry->comm, __entry->file, __entry->dev)

Maybe this is enough for POWERTOP, however for general use, the dirty
type(data/metadata) and inode number may be valuable to some users?

Thanks,
Fengguang

